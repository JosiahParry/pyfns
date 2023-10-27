.onLoad <- function(libname, pkgname){
  reticulate::source_python(
    system.file("helloworld.py", package = "pyfns"),
    envir = pyfn_env
  )
}
