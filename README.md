
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pyfns

This package serves to illustrate a minimal approach to exporting Python
functions in R packages.

The process is *fairly* simple.

- We create an environment inside of our package
- On package start-up we source python scripts using
  `reticulate::source_python()` into the new environment
- We create R wrapper functions that call the reticulated function.

Example usage:

``` r
pyfns::hello_world()
#> [1] "Helloooo world"
```

## Storing Python Scripts

Store python scripts inside of `inst/`. These files can be read using
`system.file()`. In this example `inst/helloworld.py` contains

``` py
def hello_world():
  return "Helloooo world"
```

## Creating an environment

Before we can source python scripts, we must create an environment to
soure them into. This is done in `R/env.R` like so

``` r
pyfn_env <- rlang::env()
```

## Sourcing scripts

Scripts are sourced in `R/zzz.R` in which there is an `.onLoad()`
function call. This gets called only once when the package is loaded.

``` r
.onLoad <- function(libname, pkgname){
  reticulate::source_python(
    system.file("helloworld.py", package = "pyfns"),
    envir = pyfn_env
  )
}
```

In this chunk we use `reticulate::source_python()` to bring the python
function into scope. The function needs a path to the python script that
we want to source. This is where `system.file()` comes into play. It can
access files stored in `inst`. *Note that it does not include `inst`*.
And most importantly we set `envir = pyfn_env` which is the environment
we created in `R/env.R`

## Wrapper functions

Since the functions are being sourced into `pyfn_env` they can be called
from the environment directly. In `R/env.R`, the R function
`hello_world()` is just calling the `hello_world()` python function from
the `pyfn_env`. If there were arguments we can pass them in using `...`
in the outer function or recreating the same function arguments.

``` r
#'@export
hello_world <- function() {
  pyfn_env$hello_world()
}
```
