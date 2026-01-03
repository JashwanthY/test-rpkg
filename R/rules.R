#------------------------------------------------------------------------------------------
# Rule Functions
# Purpose: Domain-specific rule functions for data transformation
#--------------------------------------------------------------------------------------------

#' Apply DM (Demographics) domain rules
#' 
#' @param data DM domain data frame
#' @return Transformed data frame with COUNTRY and AGEGR1 columns
#' @export
dm_rule <- function(data) {
  data %>%
    dplyr::mutate(
      COUNTRY = Country,  # Mixed case in CSV, standardize to uppercase
      AGEGR1 = sapply(AGE, agegrp_calc)
    )
}

#' Apply EX (Exposure) domain rules
#' 
#' @param data EX domain data frame
#' @return Transformed data frame with TRTSDT and TRTEDT columns
#' @export
ex_rule <- function(data) {
  data %>%
    dplyr::mutate(
      TRTSDT = dtc_to_dt(EXSTDT),
      TRTEDT = dtc_to_dt(EXENDT)
    )
}

#' Apply flag rules
#' 
#' @param data Data frame with TRTSDT column
#' @return Data frame with ITTFL and SAFFL columns
#' @export
flag_rule <- function(data) {
  data %>%
    dplyr::mutate(
      ITTFL = 'Y',
      SAFFL = ifelse(!is.na(TRTSDT), 'Y', 'N')
    )
}

#' Apply DS (Disposition) domain rules
#' 
#' @param data DS domain data frame
#' @return Transformed data frame with COMPLFL, EOSFL, DISCONFL, DTHFL columns
#' @export
ds_rule <- function(data) {
  data %>%
    dplyr::mutate(
      DSDECOD_upper = toupper(DSDECOD),
      COMPLFL = ifelse(DSDECOD == 'COMPLETED', 'Y', 'N'),
      EOSFL = ifelse(DSDECOD_upper %in% c('COMPLETED', 'WITHDRAWN', 'DEATH'), 'Y', 'N'),
      DISCONFL = ifelse(DSDECOD_upper != 'COMPLETED', 'Y', 'N'),
      DTHFL = ifelse(DSDECOD_upper != 'DEATH', 'Y', 'N')
    ) %>%
    dplyr::select(-DSDECOD_upper)
}

#' Apply AE (Adverse Events) domain rules
#' 
#' @param data AE domain data frame
#' @return Transformed data frame with SAFFL column
#' @export
ae_rule <- function(data) {
  data %>%
    dplyr::mutate(
      SAFFL = 'Y'
    )
}

#' Apply treatment plan rules
#' 
#' @param data Data frame with ARM column
#' @return Transformed data frame with TRT01P and TRT01PN columns
#' @export
trt_plan_rule <- function(data) {
  data %>%
    dplyr::mutate(
      TRT01P = ARM,
      TRT01PN = dplyr::case_when(
        toupper(ARM) == 'PLACEBO' ~ 0,
        toupper(ARM) == 'DRUGA' ~ 1,
        toupper(ARM) == 'DRUGB' ~ 2,
        TRUE ~ NA_real_
      )
    )
}

