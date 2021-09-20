parse_appn <- function(input, marker) {
  appn <- sprintf("APP%d", marker-0xFFE0)
  block_offset <- seek(input)
  block_length <- readBin(input, integer(), 1, size = 2, signed = FALSE, endian = "big")
  id <- readBin(input, character(), 1)
  seek(input, block_offset + block_length)
  data <- list(marker = marker, id = id, section=appn)
  attr(data, "section_offset") <- block_offset
  attr(data, "section_length") <- block_length
  class(data) <- c(appn, "jpeg_section")
  data
}
