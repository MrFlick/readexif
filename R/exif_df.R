
#' Read Exif data into a data.frame
#'
#' This function will create a data.frame with one row for each file. Each
#' Exif tag will get it's own column. A "file" column is also included with
#' the original file name.
#'
#' Note that some Exif values are difficult to represent with
#' basic R data types. One such example are "rational" values
#' that are specified with separate numerator and denominator values.
#' Those values are combined into a vector and are included in the
#' data.frame as a list column.
#'
#' Some jpeg files embed thumbnails and may contain tags for both
#' the main image and thumbnail. Tags from the thumbnail region (IDF1)
#' will have names prefixed with "Thumbnail" to avoid duplicate names.
#'
#' @param files A character vector containing paths to jpeg file.
#' @param silent_errors If TRUE, no errors are triggered when
#'   processing files but an "Error" column is added to the output
#'   if an error occurs
#'
#' @return A data.frame
#' @export
#'
#' @examples
#' sample_dir <- system.file("extdata", package="readexif")
#' sample_files <- list.files(sample_dir, pattern="\\.jpg$", full.names = TRUE)
#' exif_df(sample_files)
#'

exif_df <- function(files, silent_errors = FALSE) {
  raw <- lapply(files, function(f) {
    exif <- tryCatch(scan_jpeg(f, extract_first="Exif"), error=function(e) e)
    if (inherits(exif, "error")) {
      if (!silent_errors) stop(paste(conditionMessage(exif), "-", f))
      data.frame(file = f, Error=conditionMessage(exif))
    } else if(!is.null(exif)) {
      xx <- lapply(exif$tags, `[[`, "value")
      xx <- lapply(xx, function(x) if(length(x)>1 || is.raw(x)) I(list(x)) else x)
      xx <- as.data.frame(xx)
      names(xx) <- sapply(exif$tags, `[[`, "name")
      cbind(file=f, xx)
    } else {
      data.frame(file = f)
    }
  })
  rbindcols(raw)
}
