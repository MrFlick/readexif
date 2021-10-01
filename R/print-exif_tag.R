#' @export

print.exif_tag <- function(x, ...) {
  cols <- c("code", "name", "fmt", "count", "value")
  vals <- vapply(cols, function(f) {
    if (f=="code") return(paste0(fhex(x[[f]]), " (", x[[f]], ")"))
    if (f=="fmt") return(paste0(x[[f]], " (", tag_formats[[x[[f]]]]$desc, ")"))
    if (is.raw(x[[f]])) return(paste0("<", length(x[[f]])," byte(s)>"))
    toString(x[[f]])
  }, character(1))

  cols <- paste0(".$", cols)

  cat("TAG",
      " -- (offset: ", attr(x, "tag_offset"),
      ", length: ", attr(x, "tag_length"), ")\n", sep="")
  cat(paste0(fpad(cols),": ", vals), sep="\n")
  cat(" [tag data ",
      "offset: ", attr(x, "data_offset"),
      ", length: ", attr(x, "data_length"), "]\n", sep="")
}
