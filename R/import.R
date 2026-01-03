#' Import SDTM CSV file
#' 
#' Reads a single SDTM domain CSV file and returns it as a data frame.
#' 
#' @param domain Domain name (e.g., "DM", "EX", "DS", "AE")
#' @param csv_path Path to directory containing SDTM CSV files
#' @return Data frame containing the domain data
#' @export
#' @examples
#' \dontrun{
#' dm_data <- sdtm_import_csv("DM", "/path/to/SDTM")
#' }
sdtm_import_csv <- function(domain, csv_path) {
  utl_param_chk(name = "domain", value = domain)
  utl_param_chk(name = "csv_path", value = csv_path)
  
  csv_file <- file.path(csv_path, paste0(domain, ".csv"))
  
  if (!utl_file_exists(csv_file)) {
    utl_abort(paste("CSV file not found:", csv_file))
  }
  
  utl_trace(paste("Extracting SDTM CSV file:", csv_file))
  
  data <- readr::read_csv(
    csv_file,
    show_col_types = FALSE,
    locale = readr::locale(encoding = "UTF-8")
  )
  
  utl_trace(paste("Successfully imported", domain, "with", nrow(data), "rows"))
  
  return(data)
}

#' Extract all SDTM CSV files
#' 
#' Reads all SDTM domain CSV files (DM, EX, DS, AE) from the specified directory.
#' 
#' @param csv_path Path to directory containing SDTM CSV files
#' @return Named list containing DM, EX, DS, and AE data frames
#' @export
#' @examples
#' \dontrun{
#' sdtm_data <- sdtm_extract_all("/path/to/SDTM")
#' }
sdtm_extract_all <- function(csv_path) {
  utl_trace("Extracting all SDTM CSV files")
  
  DM <- sdtm_import_csv(domain = "DM", csv_path = csv_path)
  EX <- sdtm_import_csv(domain = "EX", csv_path = csv_path)
  DS <- sdtm_import_csv(domain = "DS", csv_path = csv_path)
  AE <- sdtm_import_csv(domain = "AE", csv_path = csv_path)
  
  return(list(DM = DM, EX = EX, DS = DS, AE = AE))
}

