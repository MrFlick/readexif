#' @export
as.data.frame.jpeg_section_list <- function(x, ..., format_hex=FALSE, collapse_other=TRUE) {
  cols <- c("marker", "section", "id")
  if (collapse_other) {
    other <- sapply(x, function(x) {
      othercount <- length(setdiff(names(x), cols))
      if(othercount>1) paste0("Yes (", othercount, ")") else ""
    })
  }

  x <- unclass(x)
  dd <- rbindcols(x, keep=cols)
  if (format_hex) {
    dd$marker <- fhex(dd$marker)
  }
  dd$offset <- sapply(x, attr, "section_offset")
  dd$length <- sapply(x, attr, "section_length")
  if (collapse_other) dd$other <- other
  dd
}
