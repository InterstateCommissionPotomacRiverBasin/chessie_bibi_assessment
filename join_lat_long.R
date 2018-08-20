#==============================================================================
#==============================================================================
# Author: Zachary M. Smith
# Created: 6/21/17
# Updated: 6/21/17
# Purpose: Merge individual raw metric tables by spatial and taxonomic 
#          resolution.
#==============================================================================
#==============================================================================
# Load the custom Chessie and BIBI R-packages, as well as, attached data.
library("BIBI")
data("master")
library("Chessie")
data("m.c")
library(MMI)
# Load dplyr for data manipulation.
library(dplyr)
#------------------------------------------------------------------------------
# Import and prepare data from Chessie BIBI database.
system.time(prep.data <- prep_data(master, odbc.name = "BIBI_2017",
                                   agg.samp.num = FALSE, development = TRUE))
#------------------------------------------------------------------------------
# Keep only the Lat/Long data.
lat.longs <- prep.data %>% 
  select(EVENT_ID, SAMPLE_NUMBER, EVENT_LATITUDE, EVENT_LONGITUDE, EVENT_LL_DATUM) %>% 
  distinct() %>% 
  rename(LATITUDE = EVENT_LATITUDE,
         LONGITUDE = EVENT_LONGITUDE,
         DATUM = EVENT_LL_DATUM)
#------------------------------------------------------------------------------
# The location of the Catchment Shapefiles.
catch.dir <- "D:/ZSmith/Projects/Chessie_BIBI/GIS/spatial_02"
# Import the Catchment Shapefiles.
catchments <- rgdal::readOGR(catch.dir, "Catchments02", stringsAsFactors = FALSE)
# Transform the HUC12 Shapefiles to prepare for leaflet.
catchments <- sp::spTransform(catchments, sp::CRS("+init=epsg:4326"))
#------------------------------------------------------------------------------
# Establish the main directory to import data from.
#main.dir <- "//Pike/data/Projects/Chessie_BIBI/REPORT/FINAL_May25_2017/2017_Data"
main.dir <- "D:/ZSmith/Projects/Chessie_BIBI/Output/May_2017"
#------------------------------------------------------------------------------
# Identify the date folder to import the data from.
date.folder <- "05_08_2017"
spatial.folder <- "BASIN"
taxa.folder <- "ORDER"
date.calc <- "5_23_17"

join_lat_long <- function(main.dir, date.folder, spatial.folder,
                             taxa.folder, date.calc, lat.longs, catchments) {
  # Update directory to the correct date folder, spatial folder, 
  # and taxonomic resolution folder.
  file.dir <- file.path(main.dir, date.folder, spatial.folder, taxa.folder)
  # Generate the string pattern of interest.
  file.pattern <- paste0("*", date.calc, "_All_Event_Ratings", "*.csv")
  # Identify all file names in the specified file directory that contain
  # the pattern generated above in the file name.
  file.name <- list.files(file.dir, pattern = glob2rx(file.pattern))
  if(length(file.name) > 1) stop("More than one file name.")
  if(length(file.name) == 0) stop("No files found with the specified pattern")
  # Import all of the file that matches the specified pattern.
  file.final <- file.path(file.dir, file.name)
  file.df <- data.table::fread(file.final, stringsAsFactors = FALSE,
                               colClasses = c(EVENT_ID = "character"))
  # Append all of the lists into a single data frame.
  scores.df <- right_join(lat.longs, file.df, by = c("EVENT_ID", "SAMPLE_NUMBER")) %>% 
    select(BIOREGION, EVENT_ID, SAMPLE_NUMBER, STATION_ID, AGENCY_CODE,
           DATE, CATEGORY, LATITUDE, LONGITUDE, DATUM, HUC_8, HUC_10, HUC_12,
           FINAL_SCORE, HALF_REF_10, REF_10, REF_25, REF_50, RATING) %>% 
    rename(SPATIAL = BIOREGION)
  #------------------------------------------------------------------------------
  # Specify the coordinates of each station.
  sp::coordinates(scores.df) <- ~ LONGITUDE + LATITUDE
  #------------------------------------------------------------------------------
  # Set the projection of the SpatialPointsDataFrame using the projection of 
  # the shapefile.
  sp::proj4string(scores.df) <- sp::proj4string(catchments)
  #------------------------------------------------------------------------------
  # Identify the catchments that contain at least one sample.
  keep.catchments <- sp::over(scores.df, catchments)
  # Keep only the catchments that were found to contain one or more samples.
  #catchments <- catchments[catchments@data$FEATUREID %in% keep.catchments$FEATUREID, ]
  # Identify the Catchment that the station is located within.
  final.df <- as.data.frame(scores.df) %>% 
    mutate(CATCHMENT = sp::over(scores.df, catchments)$FEATUREID) %>% 
    select(SPATIAL, EVENT_ID, SAMPLE_NUMBER, STATION_ID, AGENCY_CODE, DATE,
           CATEGORY, LATITUDE, LONGITUDE, DATUM, HUC_8, HUC_10, HUC_12,
           CATCHMENT, FINAL_SCORE, HALF_REF_10, REF_10, REF_25, REF_50, RATING)
  #------------------------------------------------------------------------------
  # Create a file name for the output.
  final.name <- paste(spatial.folder, taxa.folder,
                      "All_Event_Ratings", Sys.Date(), sep = "_") %>% 
    paste0(".csv")
  # Generate the file pathway for the output.
  final.dir <- file.path(file.dir, final.name)
  # Export the data frame as a csv
  write.csv(final.df, final.dir, row.names = FALSE)
  
  return(final.df)
}
#------------------------------------------------------------------------------
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
    join_lat_long(main.dir,
                  date.folder = "05_08_2017",
                  spatial.folder = spatial.x,
                  taxa.folder = taxa.x,
                  date.calc = "5_23_17",
                  lat.longs,
                  catchments)
  })
  sheet.names <- paste(proper(spatial.x), proper(taxa.res), sep = "_")
  names(final.taxa) <- sheet.names
  return(final.df)
})
