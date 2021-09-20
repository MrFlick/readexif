parse_sof <- function(input, marker) {
  sofn <- sprintf("SOF%d", marker-0xFFC0)
  block_offset <- seek(input)
  block_length <- readBin(input, integer(), 1, size = 2, signed = FALSE, endian = "big")
  data <- list(
    Precision = readBin(input, integer(), 1, size = 1, signed = FALSE, endian = "big"),
    ImageHeight = readBin(input, integer(), 1, size = 2, signed = FALSE, endian = "big"),
    ImageWidth = readBin(input, integer(), 1, size = 2, signed = FALSE, endian = "big"),
    NumberOfComponents = readBin(input, integer(), 1, size = 1, signed = FALSE, endian = "big")
  )
  seek(input, block_offset + block_length)
  make_section(marker, sofn, block_offset, block_length, .vals=data)
}
