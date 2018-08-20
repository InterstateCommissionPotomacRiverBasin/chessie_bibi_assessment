#==============================================================================
#==============================================================================
# Author: Zachary M. Smith
# Created: 04/04/2017
# Updated: 04/04/2017
# Purpose: Create maps for each year in the Chessie BIBI database.
#==============================================================================
#==============================================================================
#==============================================================================
# Load the custom Chessie and BIBI R-packages, as well as, attached data.
library("BIBI")
data("master")
library("Chessie")
data("m.c")
#==============================================================================
# Import and prepare data from Chessie BIBI database.
system.time(prep.data <- prep_data(master, odbc.name = "BIBI_2017",
                                   agg.samp.num = FALSE, development = TRUE))
#==============================================================================


setwd("D:/ZSmith/Projects/Chessie_BIBI/Output/March_2017/03_27_2017/REGION/FAMILY")

event.df <- read.csv("REGION_FAMILY_2017-03-29_All_Event_Ratings.csv", stringsAsFactors = FALSE)
keep.cols<- c("EVENT_ID", "SAMPLE_NUMBER", "AGENCY_CODE", "HUC_12", "PROJECT_ID", "PROGRAM_CODE",
              "PROJECT_NAME", "BANKS", "EPI_SUB", "EMBED", "CH_ALT",
              "RIFF", "FLOW", "BANKV", "SED", "SPCOND", "PH", "DO",
              "STRAHLER_STREAM_ORDER", "ECOREGION_LEVEL_4", "ICPRB_BIOREGION_ID",
              "ICPRB_KARST_ID", "RPS_SLOPE_MEAN", "RPS_ELEVATION_MEAN", "STATES",
              "HUC_2", "HUC_4", "HUC_6", "HUC_8", "HUC_10", "DATE", "MONTH", "JULIAN")
sub.prep <- unique(prep.data[, names(prep.data) %in% keep.cols])
common.names <- names(event.df)[names(event.df) %in% names(sub.prep)]
merged.df <- merge(event.df, sub.prep, by = common.names)
merged.df$SEASON <- ifelse(merged.df$MONTH %in% c(3:6), "SPRING", "SUMMER")



sub.keep <- c(PROJECT_ID, PROGRAM_CODE,
                PROJECT_NAME, BANKS, EPI_SUB, EMBED, CH_ALT, RIFF, FLOW,
                BANKV, SED, SPCOND, PH, DO, STRAHLER_STREAM_ORDER, 
                ECOREGION_LEVEL_4, ICPRB_BIOREGION_ID, ICPRB_KARST_ID +
                RPS_SLOPE_MEAN + RPS_ELEVATION_MEAN + STATES + MONTH + JULIAN + SEASON)

merged.df <- merged.df[complete.cases(merged.df[, keep.cols]), ]
merged.df <- as.data.frame(unclass(merged.df))
#==============================================================================
library(randomForest)
names(merged.df)
fit <- rpart(RATING ~ HUC_8 + HUC_10 + HUC_12 + PROJECT_ID, data = merged.df,
                             control = list(maxdepth = 2))
fit <- randomForest(RATING ~ PROJECT_ID + PROGRAM_CODE +
                      PROJECT_NAME + BANKS + EPI_SUB + EMBED + CH_ALT + RIFF + FLOW +
                      BANKV + SED + SPCOND + PH + DO + STRAHLER_STREAM_ORDER + 
                      ECOREGION_LEVEL_4 + ICPRB_BIOREGION_ID + ICPRB_KARST_ID +
                      RPS_SLOPE_MEAN + RPS_ELEVATION_MEAN + STATES + MONTH + JULIAN + SEASON,
                    data = merged.df,
                    importance = TRUE, 
                    ntrees = 10000)
varImpPlot(fit)



HUC_12 + PROJECT_ID + PROGRAM_CODE +
  PROJECT_NAME + BANKS + EPI_SUB + EMBED + CH_ALT + RIFF + FLOW +
  BANKV + SED + SPCOND + PH + DO + STRAHLER_STREAM_ORDER + 
  ECOREGION_LEVEL_4 + ICPRB_BIOREGION_ID + ICPRB_KARST_ID +
  RPS_SLOPE_MEAN + RPS_ELEVATION_MEAN + STATES + HUC_2+
  HUC_4 + HUC_6 + HUC_8 + HUC_10 + DATE + MONTH + JULIAN + SEASON

