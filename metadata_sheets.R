#==============================================================================
#==============================================================================
# Author: Zachary M. Smith
# Created: 06/28/2017
# Updated: 06/29/2017
# Maintained: Zachary M. Smith
# Purpose: Create csv files of Chesapeake Bay Basin HUC and Catchment 
#          information to put in metadata excel file.
#==============================================================================
#==============================================================================
# Load dplyr for data manipulation.
library(dplyr)
# Load RODBC to connect to MS Access.
library(RODBC)
#------------------------------------------------------------------------------
main.dir <- "H:/Projects/Chessie_BIBI/REPORT/FINAL_May25_2017/2017_Data/Metadata/sheets"
#==============================================================================
# HUC Sheet
#==============================================================================
channel <- RODBC::odbcConnect("BIBI_2017")
tab_huc <- RODBC::sqlFetch(channel, "TAB_HUC_12", stringsAsFactors = FALSE) %>% 
  mutate(HUC_12 = as.character(paste0("0", HUC_12)))
RODBC::odbcCloseAll()
huc.dir <- file.path(main.dir, "huc_sheet.csv")
write.csv(tab_huc, huc.dir, row.names = FALSE)
#==============================================================================
# Catchment Sheet
#==============================================================================
# The location of the Catchment Shapefiles.
catch.dir <- "D:/ZSmith/Projects/Chessie_BIBI/GIS/spatial_02"
# Import the Catchment Shapefiles.
catchments <- rgdal::readOGR(catch.dir, "Catchments02", stringsAsFactors = FALSE)
#------------------------------------------------------------------------------
# Organize the data from the spatialpolygonsdataframe into a regular dataframe.
catch.df <- as.data.frame(catchments)
#------------------------------------------------------------------------------
catch.dir <- file.path(main.dir, "catchment_sheet.csv")
write.csv(catch.df,  catch.dir, row.names = FALSE)
#==============================================================================
#==============================================================================
















