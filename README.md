
# tinyvalid

<!-- badges: start -->

[![R-CMD-check](https://github.com/raghavanvishnu/tinyvalid/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/raghavanvishnu/tinyvalid/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`tinyvalid` is a lightweight R package for **validating tabular
data**.  
It helps you confirm that your data frames:

- contain all required columns,  
- have the expected classes (e.g. integer, numeric, Date),  
- and (optionally) don’t contain unexpected extras.

It returns a tidy tibble of issues, making it easy to catch problems
early in your pipeline.

------------------------------------------------------------------------

## Installation

You can install the development version directly from GitHub:

``` r
# install.packages("pak")
pak::pak("raghavanvishnu/tinyvalid")


Example

Suppose we expect a dataset with three columns:

id (integer)

amount (numeric)

date (Date)
```

Our data frame below is missing the date column:

``` r
library(tinyvalid)
library(tibble)

df  <- tibble(id = as.integer(1:3), amount = as.numeric(1:3))
req <- c(id = "integer", amount = "numeric", date = "Date")

validate_schema(df, req)

Expected output
# A tibble: 1 × 5
  check   column expected actual status
  <chr>   <chr>  <chr>    <chr>  <chr>
1 missing date   Date     <NA>   fail
```

The result shows that the column date is missing, so the check fails.

Roadmap

Planned helper functions include:

``` r
validate_ranges() – check numeric ranges & allowed categorical sets

validate() – orchestrator that runs multiple checks and binds results
```

License

MIT © Raghavan VMVS
