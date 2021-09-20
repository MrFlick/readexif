parse_app1 <- function(input, marker) {
  block_offset <- seek(input)
  block_length <- readBin(input, integer(), 1, size = 2, signed = FALSE, endian = "big")
  id <- readBin(input, character(), 1)
  data <- if (id == "Exif") {
    parse_exif(input)
  } else {
    NULL
  }
  seek(input, block_offset + block_length)
  data <- make_section(marker, "APP1", block_offset, block_length, id=id, .vals=data)
  if ( id=="Exif" ) {
    class(data) <- c("exif", class(data))
  }
  data
}
