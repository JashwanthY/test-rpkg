#' Create ADSL dataset from SDTM CSV files
#' 
#' Main pipeline function that processes SDTM data and creates an ADSL dataset.
#' This function orchestrates the entire workflow:
#' 1. Extracts all SDTM CSV files
#' 2. Processes each domain (DM, EX, DS, AE)
#' 3. Builds ADSL components
#' 4. Merges all components into final ADSL dataset
#' 5. Writes output to CSV file
#' 
#' @param csv_path Path to directory containing SDTM CSV files
#' @param adam_lib Path to output directory for ADSL CSV file (default: "adam")
#' @return ADSL data frame
#' @export
#' @examples
#' \dontrun{
#' # Create ADSL from SDTM data
#' adsl <- create_adsl_from_csv(
#'   csv_path = "/path/to/SDTM",
#'   adam_lib = "/path/to/output"
#' )
#' }
create_adsl_from_csv <- function(csv_path, adam_lib = "adam") {
  utl_param_chk(name = "csv_path", value = csv_path)
  
  utl_trace("ADSL PIPELINE START")
  
  # Extract all SDTM data
  sdtm_data <- sdtm_extract_all(csv_path = csv_path)
  
  # Process each domain
  dm_proc <- dm_process(sdtm_data$DM)
  ex_proc <- ex_process(sdtm_data$EX)
  ds_proc <- ds_process(sdtm_data$DS)
  ae_proc <- ae_process(sdtm_data$AE)
  
  # Build ADSL components
  adsl_demog_df <- adsl_demog(dm_proc)
  adsl_trt_df <- adsl_trt(ex_proc)
  adsl_flags_df <- adsl_flags(adsl_demog_df, adsl_trt_df)
  adsl_ds_df <- adsl_ds_flags(ds_proc)
  adsl_ae_df <- adsl_ae_flags(ae_proc)
  
  # Remove saffl from ae_df to avoid duplication
  adsl_ae_no_saffl <- adsl_ae_df %>%
    dplyr::select(-saffl)
  
  # Merge all components
  adsl <- adsl_flags_df %>%
    dplyr::left_join(adsl_ds_df, by = "usubjid") %>%
    dplyr::left_join(adsl_ae_no_saffl, by = "usubjid")
  
  # Format date columns
  format_date_col <- function(date_col) {
    sapply(date_col, function(x) {
      if (is.na(x) || is.infinite(x) || x == "") {
        return("")
      } else if (inherits(x, "Date")) {
        return(format(x, "%Y-%m-%d"))
      } else if (is.numeric(x) && !is.infinite(x)) {
        return(format(as.Date(x, origin = "1970-01-01"), "%Y-%m-%d"))
      } else {
        return(as.character(x))
      }
    })
  }
  
  # Final formatting
  adsl <- adsl %>%
    dplyr::select(
      USUBJID = usubjid,
      AGE = age,
      SEX = sex,
      RACE = race,
      Country = country,
      AGEGR1 = agegr1,
      TRT01P = trt01p,
      TRT01PN = trt01pn,
      TRTSDT,
      TRTEDT,
      ITTFL,
      SAFFL,
      EOSFL = eosfl,
      DTHFL = dthfl
    ) %>%
    dplyr::mutate(
      TRTSDT = format_date_col(TRTSDT),
      TRTEDT = format_date_col(TRTEDT)
    )
  
  # Create output directory if it doesn't exist
  if (!dir.exists(adam_lib)) {
    dir.create(adam_lib, recursive = TRUE)
  }
  
  output_file <- file.path(adam_lib, "adsl.csv")
  
  # Write CSV in SAS-compatible format
  write_sas_csv <- function(df, file) {
    df <- as.data.frame(df)
    
    con <- file(file, "w")
    on.exit(close(con))
    
    header <- paste0('"', names(df), '"', collapse = ",")
    writeLines(header, con)
    
    for (i in 1:nrow(df)) {
      row <- character(ncol(df))
      for (j in 1:ncol(df)) {
        val <- df[[j]][i]
        col_name <- names(df)[j]
        if (col_name %in% c("AGE", "TRT01PN")) {
          row[j] <- as.character(val)
        } else if (col_name %in% c("TRTSDT", "TRTEDT")) {
          if (is.na(val) || val == "") {
            row[j] <- ""
          } else {
            row[j] <- as.character(val)
          }
        } else {
          if (is.na(val) || val == "") {
            row[j] <- ""
          } else {
            row[j] <- paste0('"', as.character(val), '"')
          }
        }
      }
      writeLines(paste(row, collapse = ","), con)
    }
  }
  
  write_sas_csv(adsl, output_file)
  
  utl_trace(paste("ADSL PIPELINE END - Output saved to:", output_file))
  
  return(adsl)
}

