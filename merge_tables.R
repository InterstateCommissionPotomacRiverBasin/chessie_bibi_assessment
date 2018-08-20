#==============================================================================
#==============================================================================
# Author: Zachary M. Smith
# Created: 6/21/17
# Updated: 6/21/17
# Purpose: Merge individual raw metric tables by spatial and taxonomic 
#          resolution.
#==============================================================================
#==============================================================================
# Load dplyr for data manipulation.
library(dplyr)
#------------------------------------------------------------------------------
# Establish the main directory to import data from.
main.dir <- "D:/ZSmith/Projects/Chessie_BIBI/Output/May_2017"

#------------------------------------------------------------------------------
# Identify the date folder to import the data from.
#date.folder <- "05_08_2017"
#spatial.folder <- "REGION"
#taxa.folder <- "GENUS"
#date.calc <- "5_08_17"

bind_raw_metrics <- function(main.dir, date.folder, spatial.folder,
                             taxa.folder, date.calc) {
  # Update directory to the correct date folder, spatial folder, 
  # and taxonomic resolution folder.
  file.dir <- file.path(main.dir, date.folder, spatial.folder, taxa.folder)
  # Generate the string pattern of interest.
  file.pattern <- paste0("*raw_metrics_", date.calc, "*.csv")
  # Identify all file names in the specified file directory that contain
  # the pattern generated above in the file name.
  file.names <- list.files(file.dir, pattern = glob2rx(file.pattern))
  # Import all of the identified files into a list.
  metric.list <- lapply(file.names, function(file.x) {
    file.final <- file.path(file.dir, file.x)
    data.table::fread(file.final, stringsAsFactors = FALSE)
  })
  # Append all of the lists into a single data frame.
  final.df <- bind_rows(metric.list)
  # Create a file name for the output.
  final.name <- paste(spatial.folder, taxa.folder, "raw_metrics", Sys.Date(), sep = "_") %>% 
    paste0(".csv")
  # Generate the file pathway for the output.
  final.dir <- file.path(file.dir, final.name)
  # Export the data frame as a csv
  write.csv(final.df, final.dir, row.names = FALSE)
  
  return(final.df)
}
# Function copied from : 
# http://www.sthda.com/english/wiki/r-xlsx-package-a-quick-start-guide-to-manipulate-excel-files-in-r
xlsx.writeMultipleData <- function (file, ...) {
  require(xlsx, quietly = TRUE)
  objects <- list(...)
  fargs <- as.list(match.call(expand.dots = TRUE))
  objnames <- as.character(fargs)[-c(1, 2)]
  nobjects <- length(objects)
  for (i in 1:nobjects) {
    if (i == 1)
      write.xlsx(objects[[i]], file, sheetName = objnames[i])
    else write.xlsx(objects[[i]], file, sheetName = objnames[i],
                    append = TRUE)
  }
}
# Function copied from:
#https://stackoverflow.com/questions/24956546/capitalizing-letters-r-equivalent-of-excel-proper-function
proper <- function(x) sub("(.)", ("\\U\\1"), tolower(x), pe = TRUE)
#------------------------------------------------------------------------------
# Specify all of the spatial resolutions that need to be bound.
spatial.res <- c("BASIN", "REGION", "BIOREGION")
# Specify all of the taxonomic resolutions that need to be bound.
taxa.res <- c("ORDER", "FAMILY", "GENUS")
# For each spatial resolution and each taxonomic resolution, bind
final.spatial <- lapply(spatial.res, function(spatial.x) {
  print(spatial.x)
  final.taxa <- lapply(taxa.res, function(taxa.x) {
    print(paste0("...", taxa.x))
    bind_raw_metrics(main.dir,
                    date.folder = "05_08_2017",
                    spatial.folder = spatial.x,
                    taxa.folder = taxa.x,
                    date.calc = "5_08_17")
  })
  sheet.names <- paste(proper(spatial.x), proper(taxa.res), sep = "_")
  names(final.taxa) <- sheet.names
  return(final.df)
})


test <- final.spatial[[1]]

final.excel <- c(final.spatial[[1]], final.spatial[[2]])

output.dir <- "H:/Projects/Chessie_BIBI/REPORT/FINAL_May25_2017"
excel.name <- paste("raw_metrics_", Sys.Date(), ".xlsx")
excel.dir <- file.path(output.dir, excel.name)

xlsx.writeMultipleData(excel.dir, final.excel$Region_Order, final.excel$Region_Family)

write.xlsx(final.excel$Region_Order,
           file = excel.dir,
           sheetName = "Region_Order", 
           append = FALSE)
