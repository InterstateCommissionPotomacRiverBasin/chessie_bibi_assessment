#==============================================================================
#==============================================================================
# Author: Zachary M. Smith
# Created: 2016
# Updated: 3/15/2017
# Purpose: Import and prepate Chessie BIBI data.
#==============================================================================
#==============================================================================
#Set Working directory (The folder files are imported and exported to)
#setwd("//pike/data/Projects/Chessie_BIBI/BIBI_June_2016")
#==============================================================================
#Load the BIBI package
library(BIBI)
data("master")
library(Chessie)
#library(magrittr)
#prep.data <- read.csv("prep_data_3_29_16.csv")
#==============================================================================
#Set up ODBC connection to Access Database and import necessary files
#This connection provides the most updated version of the database.
#No need to export each table from the database everytime the
#database is updated.
#RODBC is a package that allows us to extract information via an 
#OBDC connection
library(RODBC)
odbcDataSources()
#channel <- odbcConnect("test")
#channel <- odbcConnect("BIBI_ODBC")
#channel <- odbcConnect("BIBI_OCT_2017")
channel <- odbcConnect("CBIBI_2017")
#channel <- odbcConnectAccess("//Pike/data/Projects/Chessie_BIBI/CBIBI_Package_updated_Dec2016/CBIBI_Oct2016")
tab_event <- sqlFetch(channel, "TAB_EVENT", stringsAsFactors = FALSE)
#tab_event$STATION_ID <- toupper(tab_event$STATION_ID)
tab_stations <- sqlFetch(channel, "TAB_STATIONS", stringsAsFactors = FALSE)
#tab_stations$STATION_ID <- toupper(tab_stations$STATION_ID)
tab_project <- sqlFetch(channel, "TAB_PROJECT", stringsAsFactors = FALSE)
tab_wq <- sqlFetch(channel, "TAB_WQ_DATA", stringsAsFactors = FALSE)
tab_wq_param <- sqlFetch(channel, "TAB_PARAMETER_WQ", stringsAsFactors = FALSE)
tab_habitat <- sqlFetch(channel, "TAB_HABITAT_ASSESSMENT", stringsAsFactors = FALSE)
tab_hab_param <- sqlFetch(channel, "TAB_HABITAT_PARAMETERS", stringsAsFactors = FALSE)
tab_taxa <- sqlFetch(channel, "TAB_TAXONOMIC_COUNT", stringsAsFactors = FALSE)
tab_taxa$TSN_Final <- gsub("(?<![0-9])0+", "", tab_taxa$TSN_Final, perl = TRUE)
tab_huc <- sqlFetch(channel, "TAB_HUC_12", stringsAsFactors = FALSE)
tab_program <- sqlFetch(channel, "TAB_PROGRAM", stringsAsFactors = FALSE)
#tab_master <- sqlFetch(channel, "TAB_MASTER_TAXA_LIST")
num.cols <- c("BECK_CLASS", "SEL_EPTD", "ASPT",
              "INTOLERANT_URBAN", "BIBI_TV")
#tab_master[, !(names(tab_master) %in% num.cols)] <- data.frame(lapply(tab_master[, !(names(tab_master) %in% num.cols)], as.character), stringsAsFactors = FALSE)


odbcCloseAll()
# Add HUC 12 watershed characteristics to the database
#tab_huc <- read.csv("HUC_12.csv")
#karst.new <- read.csv("karst_5_26_16.csv")
#metric.class <- read.csv("Metrics_List_9_19_16.csv")
#m.c <- metric.class[, c(1, 3)]
#names(m.c) <- c("METRICS", "METRIC_CLASS")

master.df <- master
tab.taxa <- tab_taxa
tab.wq <- tab_wq
tab.habitat <- tab_habitat
tab.event <- tab_event
tab.stations <-tab_stations
tab.project <- tab_project
tab.huc <- tab_huc
sample.date = "SAMPLE_DATE_TIME"
agg.samp.num = FALSE
clean.taxa = TRUE
development = TRUE
bibi.version = 2016
month = TRUE
odbc.name <- "BIBI_2017"

#==============================================================================
# Prepare data
system.time(
prep.data <- prep_data(master, odbc.name = "BIBI_2017",
                       agg.samp.num = FALSE, development = TRUE))

