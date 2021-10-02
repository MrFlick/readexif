#' @export
as.data.frame.jpeg_section <- function(x, ..., format_hex=FALSE, include_location = FALSE) {
  first <- intersect(c("marker", "section", "id"), names(x))
  rest <- setdiff(names(x), first)
  cols <- c(first, rest)
  cols <- Filter(function(col) !is.list(x[[col]]), cols)

  xx <- lapply(cols, function(col) {
    x <- x[[col]]
    if(col=="marker" && format_hex) return(fhex(x))
    if(length(x)>1 || is.raw(x)) return(I(list(x)))
    x
  })
  names(xx) <- cols
  if(include_location) {
    xx <- c(xx, list(
      offset = attr(x, "section_offset"),
      length = attr(x, "section_length")
    ))
  }
  as.data.frame(xx)
}
