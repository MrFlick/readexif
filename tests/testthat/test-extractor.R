test_that("extract by number works", {
  q <- 0xFFDB
  test_file <- system.file("extdata/Positive_roll_film.jpg", package="readexif")
  section <- scan_jpeg(test_file, extract_first = q)
  expect_true(!is.null(section))
  expect_equal(section$marker, q)
})

test_that("extract by name works", {
  test_file <- system.file("extdata/Positive_roll_film.jpg", package="readexif")
  section <- scan_jpeg(test_file, extract_first = "SOF0")
  expect_true(!is.null(section))
  expect_equal(section$marker, 0xFFC0)
  expect_equal(section$section, "SOF0")
})

test_that("extract by prefix works", {
  test_file <- system.file("extdata/Positive_roll_film.jpg", package="readexif")
  section <- scan_jpeg(test_file, extract_first = "SOF")
  expect_true(!is.null(section))
  expect_equal(section$marker, 0xFFC0)
  expect_equal(section$section, "SOF0")
})

test_that("extract by ID works", {
  q <- "http://ns.adobe.com/xap/1.0/"
  test_file <- system.file("extdata/Lookup.jpg", package="readexif")
  section <- scan_jpeg(test_file, extract_first = q)
  expect_true(!is.null(section))
  expect_equal(section$id, q)
})

test_that("extract returns NULL if no match", {
  test_file <- system.file("extdata/Lookup.jpg", package="readexif")
  section <- scan_jpeg(test_file, extract_first = 0)
  expect_null(section)
})
