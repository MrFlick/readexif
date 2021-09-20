#' Get bytes for section of jpeg file
#'
#' This package mainly focuses on parsing Exif data but
#' there may be other metadata in the file. This
#' function allows you to extract the bytes for a section
#' identified by `scan_jpeg()`.
#'
#' Note that raw bytes for each section are not saved
#' by default. So you will need to pass the same path
#' used during the scan to the `input=` parameter.
#'
#' @param section An object of class "jpeg_section"
#' @param input A character vector or seek-able binary connection
#' @param include_marker By default the bytes are returned
#'    without the two-byte marker identifier. Set to TRUE to
#'    include this value
#'
#' @return A raw vector
#' @export
#' @seealso [scan_jpeg()]
#'
#' @examples
#' path <- system.file("extdata", "LookUp.jpg", package="readexif")
#' toc <- scan_jpeg(path)
#' toc # note the 4th block contains adobe XMP data
#' bytes <- get_section_bytes(toc[[4]], path, include_marker=TRUE)
#'
#' read_xmp <- function(bytes) {
#'   bytes <- c(bytes, as.raw(0L)) # pad with null byte
#'   # Use connection to keep track of bytes
#'   rawcon <- rawConnection(bytes)
#'   on.exit(close(rawcon))
#'   # Read section length
#'   len <- readBin(rawcon, integer(), n=1, size=2, signed=FALSE, endian = "big")
#'   # Read section ID
#'   id <- readBin(rawcon, character())
#'   # Read body. XMP happens to just use UTF-8 encoded text
#'   body <- readBin(rawcon, character())
#'   Encoding(body) <- "UTF-8" # (per the XMP spec)
#'   body <- gsub("\\s{2,}", "", body)  # trim excess whitespace
#'   return(list(len=len, id=id, body=body))
#' }
#'
#' read_xmp(bytes)

get_section_bytes <- function(section, input=NULL, include_marker=FALSE) {
  if (is.null(input)) {
    if (is.null(section$bytes)) {
      stop("No data found. You must the pass original file via input=")
    }
  } else if (is.character(input)) {
    if (length(input)>1) stop(paste("Only one file can be read at a time. Found: ", length(input)))
    input <- file(input, "rb")
    on.exit(close(input))
  } else if (is.na(input)) {
    stop("input cannot be NA -- expecting connection, character, or NULL")
  }

  offset <- attr(section, "section_offset")
  length <- attr(section, "section_length")
  if(include_marker) {
    offset <- offset - 2
    length <- length + 2
  }
  seek(input, offset)
  readBin(input, raw(), length)
}
