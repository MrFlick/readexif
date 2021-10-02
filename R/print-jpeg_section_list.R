
#' @export
print.jpeg_section_list <- function(x, ..., format_hex=TRUE) {
  m <- as.matrix(format(as.data.frame(x, format_hex=format_hex)))
  dimnames(m)[[1]] <- paste0("[[", seq.int(nrow(m)), "]]")
  print(m, quote=FALSE, right=TRUE)
}
