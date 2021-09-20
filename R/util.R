fhex <- function(x) {
  sprintf("0x%04X", x)
}

fpad <- function(x) {
  format(x, width = max(nchar(x)), justify = "left")
}

makeuniq <- function(vals) {
  unsplit(lapply(split(vals, vals), function(x) {
    if (length(x)<2) return(x)
    paste0(x, seq_along(x))
  }), vals)
}

rbindcols <- function(x, keep=NULL) {
  allcols <- unique(unlist(lapply(x, names)))
  if (!is.null(keep)) {
    allcols <- intersect(allcols, keep)
  }
  raw <- lapply(x, function(d) {
    d <- d[intersect(allcols, names(d))]
    d[setdiff(allcols, names(d))] <- NA
    as.data.frame(d)
  })
  do.call("rbind", raw)
}

make_section <- function(marker, name, offset, length, ..., .vals) {
  data <- list(marker = marker, section=name, ...)
  if (!missing(.vals)) {
    data <- c(data, .vals)
  }
  attr(data, "section_offset") <- offset
  attr(data, "section_length") <- length
  class(data) <- c(name, "jpeg_section")
  data
}
