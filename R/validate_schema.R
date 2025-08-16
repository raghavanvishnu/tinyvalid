#' Validate the schema of a data frame
#'
#' Checks that required columns exist and have the expected base class.
#'
#' @param x A data.frame or tibble.
#' @param required Named character vector of expected classes for required columns,
#'   e.g. c(id = "integer", amount = "numeric", date = "Date").
#' @param allow_extra Logical; if FALSE, flags extra columns not listed in `required`.
#'
#' @return A tibble with columns: check, column, expected, actual, status.
#'   Each row is an issue found (empty tibble if no issues).
#' @export
#' @examples
#' df <- tibble::tibble(id = 1:3, amount = as.numeric(1:3))
#' validate_schema(df, c(id = "integer", amount = "numeric", date = "Date"))
validate_schema <- function(x, required, allow_extra = TRUE) {
  stopifnot(is.data.frame(x))
  if (is.null(names(required)) || any(names(required) == "")) {
    stop("`required` must be a *named* character vector, e.g. c(id='integer').")
  }

  cols <- names(x)
  req_names <- names(required)

  # missing columns
  missing <- setdiff(req_names, cols)

  # class mismatches
  class_rows <- lapply(req_names, function(nm) {
    if (!nm %in% cols) {
      return(NULL)
    }
    exp <- required[[nm]]
    act <- class(x[[nm]])[1]
    if (!identical(exp, act)) {
      tibble::tibble(
        check = "class_mismatch",
        column = nm, expected = exp, actual = act,
        status = "fail"
      )
    } else {
      NULL
    }
  })
  class_rows <- dplyr::bind_rows(class_rows)

  # extra columns (if not allowed)
  extra_rows <- NULL
  if (!allow_extra) {
    extra <- setdiff(cols, req_names)
    if (length(extra)) {
      extra_rows <- tibble::tibble(
        check = "extra",
        column = extra,
        expected = NA_character_,
        actual = NA_character_,
        status = "fail"
      )
    }
  }

  # missing rows
  miss_rows <- NULL
  if (length(missing)) {
    miss_rows <- tibble::tibble(
      check = "missing",
      column = missing,
      expected = required[missing],
      actual = NA_character_,
      status = "fail"
    )
  }

  out <- dplyr::bind_rows(miss_rows, class_rows, extra_rows)

  # If no issues, return an empty tibble with the right columns
  if (is.null(out) || nrow(out) == 0) {
    return(tibble::tibble(
      check = character(),
      column = character(),
      expected = character(),
      actual = character(),
      status = character()
    ))
  }

  # Use base order() to avoid NSE/.data edge cases
  out[order(out$check, out$column), , drop = FALSE]
}
