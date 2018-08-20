#==============================================================================
#==============================================================================
# Author: Zachary M. Smith
# Created: 2016
# Updated: 4/25/2017
# Purpose: Import and prepare Chessie BIBI data.
#==============================================================================
#==============================================================================
# Set Working Directory to proper output folder.
setwd("D:/ZSmith/Projects/Chessie_BIBI/Output")
#==============================================================================
# Load the custom Chessie and BIBI R-packages, as well as, attached data.
library("BIBI")
data("master")
library("Chessie")
data("m.c")
#==============================================================================
# Import and prepare data from Chessie BIBI database.
system.time(prep.data <- prep_data(master, odbc.name = "CBIBI_2017",
                         agg.samp.num = FALSE, development = TRUE))
#============================================================================
channel <- RODBC::odbcConnect("CBIBI_2017")
# Import the necessary database sheets (tabs) into a list.
tab_event <- RODBC::sqlFetch(channel, "TAB_EVENT",
                                             stringsAsFactors = FALSE)
# Close the ODBC connection
RODBC::odbcCloseAll()
#==============================================================================
spatial = "REGION"
calc.date = "4_12_17_500i"
#m.c,
all.data = prep.data
tab.event = tab_event
random_event = FALSE
todays_date = format(Sys.time(), "%m_%d_%y")
main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output"
map.agg.col = "FEATUREID"
previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_12_2017/REGION"
i <- "FAMILY"
#==============================================================================
all_tables("BASIN", "4_17_17_500i", m.c, all.data = prep.data,
           tab.event = tab_event, random_event = FALSE,
           main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output", 
           map.agg.col = "FEATUREID",
           previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_17_2017/BASIN")

all_tables("REGION", "4_17_17_500i", m.c, all.data = prep.data,
           tab.event = tab_event, random_event = FALSE,
           main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output", 
           map.agg.col = "FEATUREID",
           previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_17_2017/REGION")

all_tables("BIOREGION", "4_17_17_500i", m.c, all.data = prep.data,
           tab.event = tab_event, random_event = FALSE,
           main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output", 
           map.agg.col = "FEATUREID",
           previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_17_2017/BIOREGION")
#==============================================================================
setwd("D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_17_2017/BIOREGION/FAMILY")
spatial <- "REGION"
calc.date <- "5_08_17_500i"
todays_date = format(Sys.time(), "%m_%d_%y")
todays.date <- todays_date
random_event = FALSE 
main.dir <- "D:/ZSmith/Projects/Chessie_BIBI/Output"
previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/May_2017/05_08_2017/REGION"

previous.subdir = sub("/[^/]*$", "", previous.subdir)
taxon.rank <- "FAMILY"
very.poor.thresh <- "half_10"
all.data <- prep.data
i <- "FAMILY"
sub.dir <- create_subdir(main.dir, "BIOREGION", "FAMILY")
title.me <- "TEST"
m.c
new.dir <- create_subdir(main.dir, spatial, i)
setwd(new.dir)
tab.event <- tab_event


setwd("D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_17_2017/BIOREGION/FAMILY")


all_tables("BASIN", "4_27_17_500i", m.c, all.data = prep.data,
           tab.event = tab_event, random_event = FALSE,
           main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output", 
           map.agg.col = "FEATUREID",
           previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_27_2017/BASIN")

all_tables("REGION", "4_27_17_500i", m.c, all.data = prep.data,
           tab.event = tab_event, random_event = FALSE,
           main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output", 
           map.agg.col = "FEATUREID",
           previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_27_2017/REGION")

all_tables("BIOREGION", "4_27_17_500i", m.c, all.data = prep.data,
           tab.event = tab_event, random_event = FALSE,
           main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output", 
           map.agg.col = "FEATUREID",
           previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_27_2017/BIOREGION")



#==============================================================================
all_tables("BASIN", "5_08_17_500i", m.c, all.data = prep.data,
           tab.event = tab_event, random_event = FALSE,
           main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output", 
           map.agg.col = "FEATUREID",
           previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/May_2017/05_08_2017/BASIN")
#------------------------------------------------------------------------------
all_tables("REGION", "5_08_17_500i", m.c, all.data = prep.data,
           tab.event = tab_event, random_event = FALSE,
           main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output", 
           map.agg.col = "FEATUREID",
           previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/May_2017/05_08_2017/REGION")
#------------------------------------------------------------------------------
all_tables("BIOREGION", "5_08_17_500i", m.c, all.data = prep.data,
           tab.event = tab_event, random_event = FALSE,
           main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output", 
           map.agg.col = "FEATUREID",
           previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/May_2017/05_08_2017/BIOREGION")

