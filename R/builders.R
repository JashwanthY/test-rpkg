#------------------------------------------------------------------------------------------
# ADSL Builder Functions
# Purpose: Build ADSL components (demographics, treatment, flags)
#--------------------------------------------------------------------------------------------

#' Build ADSL demographics component
#' 
#' @param dm_proc Processed DM data frame
#' @return ADSL demographics data frame
#' @export
adsl_demog <- function(dm_proc) {
  adsl_demog <- dm_proc %>%
    dplyr::select(USUBJID, AGE, SEX, AGEGR1, TRT01P, TRT01PN, COUNTRY, RACE) %>%
    dplyr::rename(usubjid = USUBJID, age = AGE, sex = SEX, agegr1 = AGEGR1, 
                  trt01p = TRT01P, trt01pn = TRT01PN, country = COUNTRY, race = RACE)
  
  return(adsl_demog)
}

#' Build ADSL treatment component
#' 
#' @param ex_proc Processed EX data frame
#' @return ADSL treatment data frame
#' @export
adsl_trt <- function(ex_proc) {
  adsl_trt <- ex_proc
  
  return(adsl_trt)
}

#' Build ADSL flags component
#' 
#' @param adsl_demog Demographics data frame
#' @param adsl_trt Treatment data frame
#' @return ADSL flags data frame
#' @export
adsl_flags <- function(adsl_demog, adsl_trt) {
  adsl_flags <- adsl_demog %>%
    dplyr::left_join(adsl_trt, by = "usubjid") %>%
    flag_rule()
  
  return(adsl_flags)
}

#' Build ADSL DS flags component
#' 
#' @param ds_proc Processed DS data frame
#' @return ADSL DS flags data frame
#' @export
adsl_ds_flags <- function(ds_proc) {
  adsl_ds <- ds_proc
  
  return(adsl_ds)
}

#' Build ADSL AE flags component
#' 
#' @param ae_proc Processed AE data frame
#' @return ADSL AE flags data frame
#' @export
adsl_ae_flags <- function(ae_proc) {
  adsl_ae <- ae_proc
  
  return(adsl_ae)
}

