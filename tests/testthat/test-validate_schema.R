test_that("flags missing columns", {
  df <- tibble::tibble(id = 1:3, amount = as.numeric(1:3))
  req <- c(id = "integer", amount = "numeric", date = "Date")
  res <- validate_schema(df, req, allow_extra = TRUE)

  expect_true(any(res$check == "missing" & res$column == "date"))
})

test_that("respects classes and extra handling", {
  df <- tibble::tibble(id = as.integer(1:3), amount = as.numeric(1:3), note = "x")
  req <- c(id = "integer", amount = "numeric")

  res1 <- validate_schema(df, req, allow_extra = TRUE)
  res2 <- validate_schema(df, req, allow_extra = FALSE)

  expect_false(any(res1$check == "class_mismatch"))
  expect_false(any(res1$check == "extra"))
  expect_true(any(res2$check == "extra" & res2$column == "note"))
})
