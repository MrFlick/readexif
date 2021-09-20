#' @export
print.exif_tag_list <- function(x, ...) {
  names <- lapply(x, `[[`, "name")
  vals <- vapply(lapply(x, `[[`, "value"), function(v) {
    if (is.raw(v)) return(paste0("<", length(v)," byte(s)>"))
    toString(v)
  }, character(1))


  cwidth <- options("width")$width
  cat("EXIF TAGS -- ", x$section,
      "(count: ", length(x),")\n", sep="")

  idx <- fpad(paste0("[[", seq.int(length(names)), "]]"))
  names <- fpad(names)
  vals <- substr(fpad(vals), 1, max(c(10, cwidth-max(nchar(names))-max(nchar(idx))-3)))

  cat(paste0(idx, " ", names,": ", vals), sep="\n")
}
