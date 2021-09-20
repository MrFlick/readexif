
#' Extract values for single Exif tag
#'
#' This function makes it easy to return the values
#' for a single Exif tag. If you need multiple tag
#' values, it would be more efficient to use `exif_df()`
#' to extract them all at once.
#'
#'
#' @param files A character vector containing paths to jpeg files
#' @param tag A numeric tag code or character tag name
#' @param fill_value A value to return if tag not present
#' @param named Should result be named with original file name?
#' @param simplify Should result be simplified to a vector (if possible)?
#' @param silent_errors If TRUE, no errors are triggered when
#'   processing files and the fill_value is used upon failure
#'
#' @return A vector or list of tag values
#' @export
#' @seealso [exif_df()]
#'
#' @examples
#' sample_dir <- system.file("extdata", package="readexif")
#' sample_files <- list.files(sample_dir, pattern="\\.jpg$", full.names = TRUE)
#' exif_value(sample_files, "Orientation", fill_value=1)
#'
exif_value <- function(files, tag, fill_value=NA, named=TRUE,
                       simplify=TRUE, silent_errors=FALSE) {
  if (is.character(tag)) {
    ntag <- get_tag_code_from_name(tag)
    if (any(is.na(ntag))) {
      stop(paste0("Could not find code for names: ",
                paste(tag[is.na(ntag)], sep=", "), ".\n",
                "See get_known_tags()"))
    }
    tag <- ntag
  }
  if (length(tag) != 1) {
    stop(paste("Expecting exactly 1 tag, found", length(tag)))
  }
  vals <- sapply(files, function(f) {
    exif <- tryCatch(scan_jpeg(f, extract_first=function(x) methods::is(x, "exif")), error=function(e) e)
    if (methods::is(exif, "error")) {
      if (!silent_errors) stop(paste(conditionMessage(exif), "-", f))
      fill_value
    } else if(!is.null(exif)) {
      codes <- lapply(exif$tags, `[[`, "code")
      idx <- which(codes == tag)
      if (length(idx)>=1) {
        exif$tags[[idx[1]]]$value
      } else {fill_value}
    } else {
      fill_value
    }
  }, simplify=simplify)
  if (!named) {
    vals <- unname(vals)
  }
  vals
}
