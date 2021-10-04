test_that("section_df returns values", {
  sample_dir <- system.file("extdata", package="readexif")
  sample_files <- file.path(sample_dir, "LookUp.jpg")
  dd <- section_df(sample_files, "SOF")
  expect_true("file" %in% names(dd))
  expect_true(!"Error" %in% names(dd))
  expect_true(nrow(dd) == 1)
  expect_equal(dd$ImageHeight, 300)
})

test_that("section_df returns first by default", {
  sample_dir <- system.file("extdata", package="readexif")
  sample_files <- file.path(sample_dir, c("LookUp.jpg", "Ducati749.jpg"))
  dd <- section_df(sample_files, "DQT")
  expect_true(nrow(dd) == 2)
  expect_true(all(table(dd$file)==1))
})

test_that("section_df allows multiple per file", {
  sample_dir <- system.file("extdata", package="readexif")
  sample_files <- file.path(sample_dir, c("LookUp.jpg", "Ducati749.jpg"))
  dd <- section_df(sample_files, "DQT", allow_multiple = TRUE)
  expect_true(nrow(dd) == 4)
  expect_true(all(table(dd$file)==2))

  dd <- section_df(sample_files, "APP", allow_multiple = TRUE)
  expect_true(nrow(dd) == 7)
  expect_equal(dd$section, c("APP0", "APP14", "APP1", "APP1", "APP0", "APP1", "APP1"))
})

test_that("section_df handles silent errors", {
  sample_dir <- system.file("extdata", package="readexif")
  sample_files <- file.path(sample_dir, c("LookUp.jpg", "Error.jpg"))
  dd <- section_df(sample_files, "SOF", silent_errors = TRUE)
  expect_true("Error" %in% names(dd))
  expect_true(grepl("not exist", dd$Error[2]))
})

test_that("section_df handles disjoint sections", {
  sample_dir <- system.file("extdata", package="readexif")
  sample_files <- file.path(sample_dir, c("LookUp.jpg", "Ducati749.jpg"))
  dd <- section_df(sample_files, "DRI")
  expect_equal(dd$section, c("DRI", NA))
})
