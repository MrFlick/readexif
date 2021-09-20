parse_app0 <- function(input, marker=0xffe0) {
  block_offset <- seek(input)
  block_length <- readBin(input, integer(), 1, size = 2, signed = FALSE, endian = "big")
  id <- readBin(input, character(), 1, size = 5)
  vmaj <- readBin(input, integer(), 1, size = 1, signed = FALSE)
  vmin <- readBin(input, integer(), 1, size = 1, signed = FALSE)
  density <- readBin(input, integer(), 1, size = 1, signed = FALSE)
  xdensity <- readBin(input, integer(), 1, size = 2, signed = FALSE, endian="big")
  ydensity <- readBin(input, integer(), 1, size = 2, signed = FALSE, endian="big")
  xthumb <- readBin(input, integer(), 1, size = 1, signed = FALSE)
  ythumb <- readBin(input, integer(), 1, size = 1, signed = FALSE)
  thumb <- readBin(input, raw(), 3*xthumb*ythumb)
  seek(input, block_offset + block_length)
  data <- list(
    id = id,
    version = c(vmaj, vmin),
    density = density,
    xdensity = xdensity,
    ydensity = ydensity,
    xthumb = xthumb,
    ythumb = ythumb,
    thumb = thumb
  )
  make_section(marker, "APP0", block_offset, block_length, .vals=data)
}
