test_that("exif_df returns tags", {
  sample_dir <- system.file("extdata", package="readexif")
  sample_files <- file.path(sample_dir, "LookUp.jpg")
  dd <- exif_df(sample_files)
  expect_true("file" %in% names(dd))
  expect_true(!"Error" %in% names(dd))
  expect_true(nrow(dd) == 1)
  expect_equal(dd$Orientation, 6)
})

test_that("exif_df combines disjoint tags", {
  sample_dir <- system.file("extdata", package="readexif")
  sample_files <- file.path(sample_dir, c("LookUp.jpg", "Ducati749.jpg"))
  dd <- exif_df(sample_files)
  expect_true(all(c("Orientation", "Flash") %in% names(dd)))
  expect_equal(dd$Orientation, c(6, NA))
  expect_equal(dd$Flash, c(NA, 24))
})

test_that("exif_df handles silent errors", {
  sample_dir <- system.file("extdata", package="readexif")
  sample_files <- file.path(sample_dir, c("LookUp.jpg", "Error.jpg"))
  dd <- exif_df(sample_files, silent_errors = TRUE)
  expect_true("Error" %in% names(dd))
  expect_true(grepl("not exist", dd$Error[2]))
})
