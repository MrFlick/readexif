create_extractor <- function(x) {
  if (is.function(x)) return(x)
  if (is.character(x)) return(function(section) {
    if (x %in% c("APP", "SOF")) {
      (!is.null(section$section) && startsWith(section$section,x))
    } else {
      (!is.null(section$section) && section$section==x) ||
        (!is.null(section$id) && section$id==x)
    }
  })
  if (is.numeric(x)) return(function(section) {
    return (!is.null(section$marker) && section$marker == x)
  })
  stop(paste0("Unable to create extractor from object of class '",
              toString(class(x)),
              "'. Expecting integer, character, or function"))
}
