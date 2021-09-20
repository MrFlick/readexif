parse_exif <- function(input) {
  skip <- readBin(input, raw(), 1) #second null byte
  block_start <- seek(input)
  align <- readChar(input, 2)
  exifEndian <- ifelse(align=="MM", "big", "little")
  aligncheck <- readBin(input, integer(), 1, size = 2, signed = FALSE, endian = exifEndian)
  if(aligncheck != 0x002A) {
    stop("Endian check failed")
  }
  dataoffset <- readBin(input, integer(), 1, size = 4, endian = exifEndian)
  if (dataoffset != 8) {
    # jump to data
    stop("data offset not yet supported")
  }
  tags <- parse_idf(input, block_start, exifEndian)

  # Ensure names are unique
  allnames <- sapply(tags, `[[`, "name")
  finalnames <- makeuniq(allnames)
  for (i in which(allnames != finalnames)) {
    tags[[i]]$name <- finalnames[i]
  }

  class(tags) <- "exif_tag_list"

  list(
    align = align,
    endian = exifEndian,
    tags = tags
  )
}

parse_idf <- function(input, block_start, endian) {
  entry_count <- readBin(input, integer(), 1, size = 2, signed = FALSE, endian = endian)
  tags <- list()
  tags <- lapply(seq.int(entry_count), function(i) parse_exif_tag(input, endian, block_start))

  next_offset <- readBin(input, integer(), 1, size = 4, endian = endian)
  sub_exif <- Filter(function(x) x$code == 0x8769, tags)

  if (length(sub_exif)==1) {
    seek(input, sub_exif[[1]]$value + block_start)
    camera <- parse_idf(input, block_start, endian)
    tags <- c(tags, camera)
  }
  if (next_offset != 0) {
    seek(input, next_offset + block_start)
    thumb <- parse_idf(input, block_start, endian)
    thumb <- lapply(thumb, function(x) {
      if (!is.null(x$name) && !grepl("^Thumb", x$name)) {
        x$name <- paste0("Thumbnail", x$name)
      }
      x
    })
    tags <- c(tags, thumb)
  }
  tags
}

tag_formats = list(
  list(size=1, desc="unsigned byte", parse=function(x, n, e) readBin(x, integer(), n, size=1, signed = FALSE, endian = e)),
  list(size=1, desc="ascii string", parse=function(x, n, e) readBin(x, character(), 1)),
  list(size=2, desc="unsigned short", parse=function(x, n, e) readBin(x, integer(), n, size=2, signed = FALSE, endian = e)),
  list(size=4, desc="unsigned long", parse=function(x, n, e) readBin(x, integer(), n, size=4, endian = e)),
  list(size=8, desc="unsigned rational", parse=function(x, n, e) readBin(x, integer(), 2*n, size=4, endian = e)),
  list(size=1, desc="signed byte", parse=function(x, n, e) readBin(x, integer(), n, size=1, signed = TRUE, endian = e)),
  list(size=1, desc="undefined", parse=function(x, n, e) readBin(x, raw(), n)),
  list(size=2, desc="signed short", parse=function(x, n, e) readBin(x, integer(), n, size=2, signed = TRUE, endian = e)),
  list(size=4, desc="signed long", parse=function(x, n, e) readBin(x, integer(), n, size=4, signed = TRUE, endian = e)),
  list(size=8, desc="signed rational", parse=function(x, n, e) readBin(x, integer(), 2*n, size=4, signed = TRUE, endian = e)),
  list(size=4, desc="single float", parse=function(x, n, e) readBin(x, numeric(), n, size=4, signed = TRUE, endian = e)),
  list(size=8, desc="double float", parse=function(x, n, e) readBin(x, numeric(), n, size=8, signed = TRUE, endian = e))
)

parse_exif_tag <- function(input, endian, block_start=0) {
  tag_offset <- seek(input)

  code <- readBin(input, integer(), 1, size = 2, signed=FALSE, endian = endian)
  val_fmt <- readBin(input, integer(), 1, size = 2, signed=FALSE, endian = endian)
  val_count <- readBin(input, integer(), 1, size = 4, endian = endian)

  fmt_parser <- tag_formats[[val_fmt]]
  byte_count <- fmt_parser$size * val_count

  if (byte_count <= 4) {
    data_offset <- seek(input)
    data <- readBin(input, raw(), 4)
  } else {
    data_offset <- readBin(input, integer(), 1, size=4, endian=endian)
    reset_offset <- seek(input)
    if(data_offset < 0) {
      stop(paste0("negative jump for tag data detected (tag offset: ", tag_offset, ")"))
    }
    data_offset <- block_start + data_offset
    seek(input, data_offset, origin="start")
    data <- readBin(input, raw(), byte_count)
    seek(input, reset_offset, origin="start")
  }

  tag <- list(
    code = code,
    fmt = val_fmt,
    count = val_count,
    name = get_tag_name(code, fill_na=TRUE),
    value = fmt_parser$parse(data, val_count, endian))
  attr(tag, "tag_offset") <- tag_offset
  attr(tag, "tag_length") <- 12
  attr(tag, "data_offset") <- data_offset
  attr(tag, "data_length") <- byte_count
  tag
}

