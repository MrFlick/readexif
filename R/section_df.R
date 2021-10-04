
#' Read section data into a data.frame
#'
#' This function will create a data.frame with rows
#' for each of the requested files and columns for
#' the different section properties.
#'
#' This is only useful for a few sections like APP0
#' or SOF where the data is in a standard format. Data
#' for most other sections are not parsed.
#'
#' Note that the Exif tags will not be included in the
#' data.frame. If you wish to extract the Exif data,
#' use [exif_df()] instead.
#'
#' @param files A character vector containing paths to jpeg files.
#' @param extract To specify which sections to extract,
#'     you may provide the marker number, the section name, the
#'     section ID, or a function that will take a section and
#'     return TRUE for the section you want to extract.
#' @param silent_errors If TRUE, no errors are triggered when
#'   processing files but an "Error" column is added to the output
#'   if an error occurs
#' @param allow_multiple The default (FALSE) will only return
#'   the first matching section from each file. Set to TRUE
#'   to allow multiple matches per file
#' @param ... Options passed to as.data.frame.jpeg_section
#'
#' @return A data.frame
#' @export
#' @seealso [exif_df()]
#'
#' @examples
#' sample_dir <- system.file("extdata", package="readexif")
#' sample_files <- list.files(sample_dir, pattern="\\.jpg$", full.names = TRUE)
#' # Get all the Start of Frame (SOF) sections to get
#' # image heights and widths
#' section_df(sample_files, "SOF")
#'

section_df <- function(files, extract=NULL, silent_errors = FALSE, allow_multiple = FALSE, ...) {
  if (allow_multiple) extract <- create_extractor(extract)
  raw <- lapply(files, function(f) {
    if (allow_multiple) {
      sections <- tryCatch({
        Filter(extract, scan_jpeg(f))
      }, error=function(e) e)
    } else {
      sections <- tryCatch({
        if (is.null(extract)) {
          scan_jpeg(f, extract_first=NULL)[1]
        } else {
          temp <- scan_jpeg(f, extract_first=extract)
          if (!is.null(temp)) list(temp) else temp
        }
      }, error=function(e) e)
    }
    if (inherits(sections, "error")) {
      if (!silent_errors) stop(paste(conditionMessage(sections), "-", f))
      data.frame(file = f, Error=conditionMessage(sections))
    } else if(!is.null(sections)) {
      cbind(file=f, rbindcols(lapply(sections, as.data.frame, ...)))
    } else {
      data.frame(file = f)
    }
  })
  rbindcols(raw)
}
