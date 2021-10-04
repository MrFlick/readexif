#' Scan jpeg file for section locations
#'
#' A jpeg file is made up of a bunch of different sections
#' Some of these sections contain image metadata and other
#' sections contain the image data itself.
#'
#' This function will find the different sections located
#' in the beginning of the file before the image data. It
#' will identify the byte offset and length for each of
#' these sections. Exif data can be included in one
#' of theses sections, and if found, this data is parsed
#' into the different key/value/format information.
#'
#' @param input A character path to a jpeg file or a seek-able connection object
#' @param extract_first (Optional) If you only to extract a single section,
#'     you may provide the marker number, the section name, the
#'     section ID, or a function that will take a section and
#'     return TRUE for the section you want to extract. Only
#'     the first instance of a matching section is returned.
#'     If no sections match, NULL will be returned.
#'
#' @return A list containing image metadata and tags if `extract_first` is
#'     NULL. Otherwise only the matching section is returned and NULL is
#'     returned if no matching sections are found
#' @export
#'
#' @examples
#' sample_file <- system.file("extdata", "Iguana_iguana_male_head.jpg", package="readexif")
#' scan_jpeg(sample_file)
#' as.data.frame(scan_jpeg(sample_file))

scan_jpeg <- function(input, extract_first=NULL) {
  if (is.character(input)) {
    if (length(input)>1) stop(paste("Only one file can be read at a time. Found: ", length(input)))
    if (!file.exists(input)) stop(paste("File does not exist: ", input))
    input <- file(input, "rb")
    on.exit(close(input))
  } else if (is.na(input)) {
    return(NULL)
  }
  if (!is.null(extract_first)) {
    extract_first <- create_extractor(extract_first)
  }
  magic <- readBin(input, integer(), 1, size = 2, signed = FALSE, endian = "big")
  if (magic != 0xffd8) {
    stop(paste0("Invalid opening bytes. Found ", sprintf("0x%04X", magic),
               " but expected ", fhex(0xffd8)))
  }
  sections <- list()
  marker <- readBin(input, integer(), 1, size = 2, signed = FALSE, endian = "big")
  keep_scanning = TRUE
  while (keep_scanning) {
    section <- if (marker == 0xffe0) {
      parse_app0(input, marker)
    } else if (marker == 0xffe1) {
      parse_app1(input, marker)
    } else if (marker >= 0xffe2 && marker <= 0xffef) {
      parse_appn(input, marker)
    } else if (marker == 0xffc4) {
      parse_jpeg_section(input, marker, "DHT")
    } else if (marker == 0xffcc) {
      parse_jpeg_section(input, marker, "DAC")
    } else if (marker == 0xffdb) {
      parse_jpeg_section(input, marker, "DQT")
    } else if (marker == 0xffdd) {
      parse_jpeg_section(input, marker, "DRI")
    } else if (marker >= 0xffc0 && marker <= 0xffcb) {
      parse_sof(input, marker)
    } else if (marker == 0xfffe) {
      parse_jpeg_comment(input, marker)
    } else if (marker == 0xffda) {
      keep_scanning <- FALSE
      parse_jpeg_section(input, marker, "SOS")
    } else {
      stop(paste("Unknown marker", fhex(marker)))
      keep_scanning <- FALSE
      NULL
    }
    if (!is.null(extract_first)) {
      if (extract_first(section)) return(section)
    } else {
      sections <- c(sections, list(section))
    }
    marker <- readBin(input, integer(), 1, size = 2, signed = FALSE, endian = "big")
  }
  if (is.null(extract_first)) {
    class(sections) <- "jpeg_section_list"
    sections
  } else {
    NULL
  }
}

parse_jpeg_section <- function(input, marker, name) {
  block_offset <- seek(input)
  block_length <- readBin(input, integer(), 1, size = 2, signed = FALSE, endian = "big")
  seek(input, block_offset + block_length)
  make_section(marker, name, block_offset, block_length)
}

parse_jpeg_comment <- function(input, marker) {
  block_offset <- seek(input)
  block_length <- readBin(input, integer(), 1, size = 2, signed = FALSE, endian = "big")
  comment <- readBin(input, character(), 1)
  seek(input, block_offset + block_length)
  make_section(marker, "COM", block_offset, block_length, value=comment)
}


