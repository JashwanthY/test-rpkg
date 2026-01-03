#' Process DM (Demographics) domain
#' 
#' Processes the DM domain by applying rules and treatment plan rules.
#' 
#' @param DM DM domain data frame
#' @return Processed DM data frame
#' @export
dm_process <- function(DM) {
  dm_s <- DM %>%
    dplyr::arrange(USUBJID)
  
  dm_proc <- dm_s %>%
    dm_rule() %>%
    trt_plan_rule()
  
  return(dm_proc)
}

#' Process EX (Exposure) domain
#' 
#' Processes the EX domain by applying rules and aggregating treatment dates.
#' 
#' @param EX EX domain data frame
#' @return Processed EX data frame with usubjid, TRTSDT, TRTEDT columns
#' @export
ex_process <- function(EX) {
  ex_s <- EX %>%
    dplyr::arrange(USUBJID, EXSTDT)
  
  ex_with_dates <- ex_s %>%
    ex_rule()
  
  ex_proc <- ex_with_dates %>%
    dplyr::group_by(USUBJID) %>%
    dplyr::summarise(
      TRTSDT = min(TRTSDT, na.rm = TRUE),
      TRTEDT = max(TRTEDT, na.rm = TRUE),
      .groups = 'drop'
    ) %>%
    dplyr::ungroup() %>%
    dplyr::rename(usubjid = USUBJID)
  
  ex_proc$TRTSDT[is.infinite(ex_proc$TRTSDT)] <- as.Date(NA)
  ex_proc$TRTEDT[is.infinite(ex_proc$TRTEDT)] <- as.Date(NA)
  
  ex_proc$TRTEDT[is.na(ex_proc$TRTEDT)] <- ex_proc$TRTSDT[is.na(ex_proc$TRTEDT)]
  
  return(ex_proc)
}

#' Process DS (Disposition) domain
#' 
#' Processes the DS domain by applying rules and extracting end-of-study flags.
#' 
#' @param DS DS domain data frame
#' @return Processed DS data frame with usubjid, eosfl, dthfl columns
#' @export
ds_process <- function(DS) {
  ds_s <- DS %>%
    dplyr::arrange(USUBJID, DSSTDT)
  
  ds_proc <- ds_s %>%
    ds_rule() %>%
    dplyr::group_by(USUBJID) %>%
    dplyr::slice_tail(n = 1) %>%
    dplyr::ungroup() %>%
    dplyr::select(USUBJID, EOSFL, DTHFL) %>%
    dplyr::rename(usubjid = USUBJID, eosfl = EOSFL, dthfl = DTHFL)
  
  return(ds_proc)
}

#' Process AE (Adverse Events) domain
#' 
#' Processes the AE domain by applying rules and extracting safety flags.
#' 
#' @param AE AE domain data frame
#' @return Processed AE data frame with usubjid, saffl columns
#' @export
ae_process <- function(AE) {
  ae_s <- AE %>%
    dplyr::arrange(USUBJID, AESTDT)
  
  ae_proc <- ae_s %>%
    ae_rule() %>%
    dplyr::group_by(USUBJID) %>%
    dplyr::slice_head(n = 1) %>%
    dplyr::ungroup() %>%
    dplyr::select(USUBJID, SAFFL) %>%
    dplyr::rename(usubjid = USUBJID, saffl = SAFFL)
  
  return(ae_proc)
}

