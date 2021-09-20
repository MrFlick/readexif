test_that("no duplicate exif tags", {
  expect_equal(anyDuplicated(readexif:::tag_names$code), 0)
  expect_equal(anyDuplicated(readexif:::tag_names$name), 0)
})


test_that("can get tag names", {
  expect_equal(get_tag_name(0x0112), "Orientation")
  expect_true(is.na(get_tag_name(5)))
  expect_equal(get_tag_name(5, fill_na=TRUE), "x0005")
})
