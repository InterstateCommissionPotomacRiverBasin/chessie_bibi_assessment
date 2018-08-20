#==============================================================================
#==============================================================================
# Author: Zachary M. Smith
# Created: 06/29/2017
# Updated: 06/29/2017
# Maintained: Zachary M. Smith
# Purpose: Join Region family-level scores and ratings with HUC and catchment
# information in the Potomac River watershed. Data being handed off to 
# C. Buchanan for analysis. Analysis being conducted for Scott Kaiser at
# the Potomac Conservancy.
#==============================================================================
#==============================================================================
# Load readxl for importing data from xlsx files.
library(readxl)
#------------------------------------------------------------------------------
main.dir <- "//Pike/data/Projects/Chessie_BIBI/REPORT/FINAL_May25_2017/2017_Data"
#------------------------------------------------------------------------------
meta.file <- "Metadata/Metadata.xlsx"
meta.dir <- file.path(main.dir , meta.file)
huc.df <- read_excel(meta.dir, sheet = "HUC") %>% 
  select(HUC_12, Acres, SQ_MILE) %>% 
  rename(HUC12_ACRES = Acres,
         HUC12_SQMILE = SQ_MILE)
catch.df <- read_excel(meta.dir, sheet = "Catchment") %>% 
  select(FEATUREID, AreaSqKM) %>% 
  rename(CATCHMENT = FEATUREID,
         CATCHMENT_SQKM = AreaSqKM) %>% 
  mutate(CATCHMENT = as.character(CATCHMENT))
#------------------------------------------------------------------------------
scores.file <- "Scores_Ratings/BIBI_Scores_Ratings_06292017.xlsx"
scores.dir <- file.path(main.dir, scores.file)
scores.df <- read_excel(scores.dir, sheet = "Region_Family")
#------------------------------------------------------------------------------
join.df <- left_join(scores.df, huc.df, by = "HUC_12")
join.df <- left_join(join.df, catch.df, by = "CATCHMENT")
#------------------------------------------------------------------------------
potomac.df <- join.df %>% 
  mutate(HUC_12 = as.character(HUC_12)) %>% 
  filter(grepl("^207", HUC_12))
#------------------------------------------------------------------------------
output.main <- "C:/Users/zsmith/Desktop"
output.name <- paste0("potomac_region_fam_scores", Sys.Date(), ".csv")
output.dir <- file.path(output.main, output.name)
write.csv(potomac.df, output.dir, row.names = FALSE)
