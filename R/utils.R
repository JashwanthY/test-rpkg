#------------------------------------------------------------------------------------------
# Utility Functions
# Purpose: Utility functions for error handling, file checks, and tracing
#--------------------------------------------------------------------------------------------

#' Check if a dataset exists
#' @param ds_name Name of the dataset
#' @return Logical indicating if dataset exists
#' @keywords internal
utl_ds_exists <- function(ds_name) {
  exists(ds_name, envir = .GlobalEnv)
}

#' Check if a file exists
#' @param file Path to file
#' @return Logical indicating if file exists
#' @keywords internal
utl_file_exists <- function(file) {
  file.exists(file)
}

#' Abort with error message
#' @param msg Error message
#' @keywords internal
utl_abort <- function(msg) {
  stop(paste("ERROR:", msg), call. = FALSE)
}

#' Require a condition to be true
#' @param condition Logical condition
#' @param msg Error message if condition is false
#' @keywords internal
utl_require <- function(condition, msg) {
  if (!condition) {
    utl_abort(msg)
  }
}

#' Check that a parameter is not null or empty
#' @param name Parameter name
#' @param value Parameter value
#' @keywords internal
utl_param_chk <- function(name, value) {
  if (is.null(value) || length(value) == 0 || (is.character(value) && nchar(value) == 0)) {
    utl_abort(paste("Missing required parameter:", name))
  }
}

#' Print trace message
#' @param msg Message to print
#' @keywords internal
utl_trace <- function(msg) {
  cat(paste("NOTE: [TRACE]", msg, "\n"))
}

