test_that("exif value by name", {
  sample_dir <- system.file("extdata", package="readexif")
  sample_files <- file.path(sample_dir, c("LookUp.jpg", "Ducati749.jpg"))
  vals <- exif_value(sample_files, "Orientation", fill_value=1)
  expect_equal(vals, setNames(c(6, 1), sample_files))
})

test_that("exif value bad name error", {
  sample_dir <- system.file("extdata", package="readexif")
  sample_files <- file.path(sample_dir, c("LookUp.jpg", "Ducati749.jpg"))
  expect_error(exif_value(sample_files, "BadTag"), "could not find code",  ignore.case = TRUE)
})

test_that("exif value by code", {
  sample_dir <- system.file("extdata", package="readexif")
  sample_files <- file.path(sample_dir, c("Ducati749.jpg", "LookUp.jpg"))
  vals <- exif_value(sample_files, 0x0112, fill_value=1)
  expect_equal(vals, setNames(c(1, 6), sample_files))
})

test_that("exif values can be unnamed", {
  sample_dir <- system.file("extdata", package="readexif")
  sample_files <- file.path(sample_dir, c("Ducati749.jpg", "LookUp.jpg"))
  vals <- exif_value(sample_files, 0x0112, fill_value=0, named=FALSE)
  expect_equal(vals, c(0, 6))
})

test_that("exif values with bad path gives error", {
  sample_dir <- system.file("extdata", package="readexif")
  sample_files <- file.path(sample_dir, c("LookUp.jpg", "Error.jpg"))
  expect_error(exif_value(sample_files, 0x0112))
})

test_that("exif values with silent error returns fill", {
  sample_dir <- system.file("extdata", package="readexif")
  sample_files <- file.path(sample_dir, c("LookUp.jpg", "Error.jpg"))
  vals <- exif_value(sample_files, 0x0112, silent_error=TRUE)
  expect_equal(vals, setNames(c(6, NA), sample_files))
})

test_that("exif values simplify by default", {
  sample_dir <- system.file("extdata", package="readexif")
  sample_files <- file.path(sample_dir, c("LookUp.jpg", "Ducati749.jpg", "Positive_roll_film.jpg"))
  vals <- exif_value(sample_files, "XResolution")
  expect_true(is.array(vals))
  expect_equal(dim(vals), c(2, 3))
})

test_that("exif values can turn off simplify", {
  sample_dir <- system.file("extdata", package="readexif")
  sample_files <- file.path(sample_dir, c("LookUp.jpg", "Ducati749.jpg", "Positive_roll_film.jpg"))
  vals <- exif_value(sample_files, "XResolution", simplify = FALSE)
  expect_true(is.list(vals))
  expect_equal(lengths(vals), setNames(c(2, 2, 2), sample_files))
})

