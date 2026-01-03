#------------------------------------------------------------------------------------------
# Logic Functions
# Purpose: Utility functions for age group calculation and date conversion
#--------------------------------------------------------------------------------------------

#' Calculate age group
#' 
#' Categorizes age into groups: <65 or >=65
#' 
#' @param age Numeric age value
#' @return Character string: '<65', '>=65', or NA
#' @export
#' @examples
#' agegrp_calc(45)  # Returns '<65'
#' agegrp_calc(70)  # Returns '>=65'
#' agegrp_calc(NA)  # Returns NA
agegrp_calc <- function(age) {
  if (!is.na(age)) {
    if (age < 65) {
      return('<65')
    } else {
      return('>=65')
    }
  }
  return(NA_character_)
}

#' Convert DTC (Date/Time Character) to Date
#' 
#' Converts various date string formats to Date objects.
#' Supports formats: M/D/YYYY, YYYY-MM-DD, and YYYYMMDD (SAS format).
#' 
#' @param dtc Character string or vector of date strings
#' @return Date object or vector of Date objects
#' @export
#' @examples
#' dtc_to_dt("2023-02-28")
#' dtc_to_dt("2/28/2023")
#' dtc_to_dt("20230228")
dtc_to_dt <- function(dtc) {
  # Handle vector input
  if (length(dtc) > 1) {
    return(sapply(dtc, dtc_to_dt))
  }
  
  # Handle single value
  if (is.na(dtc) || is.null(dtc) || dtc == "") {
    return(as.Date(NA))
  }
  
  # Try multiple date formats
  # Format 1: M/D/YYYY (e.g., "2/28/2023")
  date_obj <- tryCatch(
    as.Date(dtc, format = "%m/%d/%Y"),
    error = function(e) NULL,
    warning = function(w) NULL
  )
  
  # Format 2: YYYY-MM-DD (e.g., "2023-02-28")
  if (is.null(date_obj) || is.na(date_obj)) {
    date_obj <- tryCatch(
      as.Date(dtc, format = "%Y-%m-%d"),
      error = function(e) NULL,
      warning = function(w) NULL
    )
  }
  
  # Format 3: YYYYMMDD (SAS format yymmdd10.)
  if (is.null(date_obj) || is.na(date_obj)) {
    date_obj <- tryCatch(
      as.Date(dtc, format = "%Y%m%d"),
      error = function(e) NULL,
      warning = function(w) NULL
    )
  }
  
  if (is.null(date_obj) || is.na(date_obj)) {
    return(as.Date(NA))
  }
  
  return(date_obj)
}

