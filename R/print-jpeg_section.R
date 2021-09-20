#' @export

print.jpeg_section <- function(x, ...) {
  first <- intersect(c("marker", "section", "id"), names(x))
  rest <- setdiff(names(x), c("marker", first))

  cols <- c(first, rest)
  vals <- vapply(cols, function(f) {
    if (f=="marker") return(paste0(fhex(x[[f]]), " (", x[[f]], ")"))
    if (is.raw(x[[f]])) return(paste0("<", length(f[[x]])," byte(s)>"))
    if (f=="tags") return("<exif tags>")
    as.character(x[[f]])
  }, character(1))

  cols <- paste0(".$", cols)

  cat("SECTION ", x$section,
      " -- (offset: ", attr(x, "section_offset"),
      ", length: ", attr(x, "section_length"), ")\n", sep="")
  cat(paste0(fpad(cols),": ", fpad(vals)), sep="\n")
}
