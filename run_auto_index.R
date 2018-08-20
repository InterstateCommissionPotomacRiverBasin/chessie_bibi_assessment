#==============================================================================
#==============================================================================
# Author: Zachary M. Smith
# Created: 2016
# Updated: 4/17/2017
# Purpose: Import and prepate Chessie BIBI data.
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
system.time(prep.data <- prep_data(master, odbc.name = "BIBI_2017",
                                   agg.samp.num = FALSE, development = TRUE))
#==============================================================================
# Generate an input date for todays_date.
my.date <- paste(format(Sys.Date(), format = "%m_%d_%y"), "500i", sep = "_") 
if (substr(my.date, 1, 1) %in% "0") my.date <- substr(my.date, 2, nchar(my.date))
#==============================================================================
# BAsin Index
#==============================================================================
system.time(auto_index(prep.data, "BASIN", "ORDER",
                       calc.date = "04_14_17",
                       format(Sys.time(), "%m_%d_%y"), jack.runs = 500,
                       todays_date = my.date,
                       num.itr = "50i",
                       main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output",
                       previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_14_2017/BASIN/ORDER"))
#------------------------------------------------------------------------------
system.time(auto_index(prep.data, "BASIN", "FAMILY",
                       calc.date = "04_14_17",
                       format(Sys.time(), "%m_%d_%y"), jack.runs = 500,
                       todays_date = my.date,
                       num.itr = "50i",
                       main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output",
                       previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_14_2017/BASIN/FAMILY"))
#------------------------------------------------------------------------------
system.time(auto_index(prep.data, "BASIN", "GENUS",
                       calc.date = "04_15_17",
                       format(Sys.time(), "%m_%d_%y"), jack.runs = 500,
                       todays_date = my.date,
                       num.itr = "50i",
                       main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output",
                       previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_14_2017/BASIN/GENUS"))
#==============================================================================
# Coastal Indices
#==============================================================================
system.time(auto_index(prep.data, "COAST", "ORDER",
                       calc.date = "04_15_17",
                       format(Sys.time(), "%m_%d_%y"), jack.runs = 500,
                       todays_date = my.date,
                       num.itr = "50i",
                       main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output",
                       previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_15_2017/REGION/ORDER"))
#------------------------------------------------------------------------------
system.time(auto_index(prep.data, "COAST", "FAMILY",
                       calc.date = "04_15_17",
                       format(Sys.time(), "%m_%d_%y"), jack.runs = 500,
                       todays_date = my.date,
                       num.itr = "50i",
                       main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output",
                       previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_15_2017/REGION/FAMILY"))

#------------------------------------------------------------------------------
system.time(auto_index(prep.data, "COAST", "GENUS",
                       calc.date = "04_15_17",
                       format(Sys.time(), "%m_%d_%y"), jack.runs = 500,
                       todays_date = my.date,
                       num.itr = "50i",
                       main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output",
                       previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_15_2017/REGION/GENUS"))
#==============================================================================
# Inland Indices
#==============================================================================
system.time(auto_index(prep.data, "INLAND", "ORDER",
                       calc.date = "04_15_17",
                       format(Sys.time(), "%m_%d_%y"), jack.runs = 500,
                       todays_date = my.date,
                       num.itr = "50i",
                       main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output",
                       previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_15_2017/REGION/ORDER"))
#------------------------------------------------------------------------------
system.time(auto_index(prep.data, "INLAND", "FAMILY",
                       calc.date = "04_15_17",
                       format(Sys.time(), "%m_%d_%y"), jack.runs = 500,
                       todays_date = my.date,
                       num.itr = "50i",
                       main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output",
                       previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_15_2017/REGION/FAMILY"))
#------------------------------------------------------------------------------
system.time(auto_index(prep.data, "INLAND", "GENUS",
                       calc.date = "04_15_17",
                       format(Sys.time(), "%m_%d_%y"), jack.runs = 500,
                       todays_date = my.date,
                       num.itr = "50i",
                       main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output",
                       previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_15_2017/REGION/GENUS"))
#==============================================================================
# Bioregions
#==============================================================================
bioregions <- c("CA", "BLUE", "NAPU", "NCA", "NRV", "SRV", 
                "MAC", "SEP", "PIED", "UNP", "LNP", "SGV")

for(i in bioregions){
  print(paste("Start Order-Level", i))
  system.time(auto_index(prep.data, i, "ORDER",
                         calc.date = "04_15_17",
                         format(Sys.time(), "%m_%d_%y"), jack.runs = 500,
                         todays_date = my.date,
                         num.itr = "50i",
                         main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output",
                         previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_15_2017/BIOREGION/ORDER"))
}

  #----------------------------------------------------------------------------
bioregions <- c("CA", "BLUE", "NAPU", "NCA", "NRV", "SRV", 
                "MAC", "SEP", "PIED", "UNP", "LNP", "SGV")
for(i in bioregions){
  print(paste("Start Family-Level", i))
  system.time(auto_index(prep.data, i, "FAMILY",
                         calc.date = "04_15_17",
                         format(Sys.time(), "%m_%d_%y"), jack.runs = 500,
                         todays_date = my.date,
                         num.itr = "50i",
                         main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output",
                         previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_15_2017/BIOREGION/FAMILY"))
}
  #----------------------------------------------------------------------------
bioregions <- c("CA", "BLUE", "NAPU", "NCA", "NRV", "SRV", 
                "MAC", "SEP", "PIED", "UNP", "LNP", "SGV")
for(i in bioregions){
  print(paste("Start Genus-Level", i))
  system.time(auto_index(prep.data, i, "GENUS",
                         calc.date = "04_15_17",
                         format(Sys.time(), "%m_%d_%y"), jack.runs = 500,
                         todays_date = my.date,
                         num.itr = "50i",
                         main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output",
                         previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_15_2017/BIOREGION/GENUS"))
}
#==============================================================================
#Check


my.data <- prep.data
bioregion <- "COAST"
taxon_rank <- "FAMILY"
calc.date = "04_15_17"
format(Sys.time(), "%m_%d_%y")
jack.runs = 500
todays_date = my.date
todays.date <- "04_26_17"
num.itr = "50i"
main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output"
previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/April_2017/04_15_2017/REGION/FAMILY"
seed <- TRUE
prod_date <- calc.date


system.time(auto_index(prep.data, "COAST", "ORDER",
                       calc.date = "05_08_17",
                       format(Sys.time(), "%m_%d_%y"), jack.runs = 500,
                       todays_date = my.date,
                       num.itr = "50i",
                       main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output",
                       previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/May_2017/05_08_2017/REGION/ORDER"))

#------------------------------------------------------------------------------

system.time(auto_index(prep.data, "COAST", "FAMILY",
                       calc.date = "05_08_17",
                       format(Sys.time(), "%m_%d_%y"), jack.runs = 500,
                       todays_date = my.date,
                       num.itr = "50i",
                       main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output",
                       previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/May_2017/05_08_2017/REGION/FAMILY"))

#------------------------------------------------------------------------------
system.time(auto_index(prep.data, "COAST", "GENUS",
                       calc.date = "05_08_17",
                       format(Sys.time(), "%m_%d_%y"), jack.runs = 500,
                       todays_date = my.date,
                       num.itr = "50i",
                       main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output",
                       previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/May_2017/05_08_2017/REGION/GENUS"))
#==============================================================================
#==============================================================================
# Inland Indices
#==============================================================================
system.time(auto_index(prep.data, "INLAND", "ORDER",
                       calc.date = "05_08_17",
                       format(Sys.time(), "%m_%d_%y"), jack.runs = 500,
                       todays_date = my.date,
                       num.itr = "50i",
                       main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output",
                       previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/May_2017/05_08_2017/REGION/ORDER"))
#------------------------------------------------------------------------------
system.time(auto_index(prep.data, "INLAND", "FAMILY",
                       calc.date = "05_08_17",
                       format(Sys.time(), "%m_%d_%y"), jack.runs = 500,
                       todays_date = my.date,
                       num.itr = "50i",
                       main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output",
                       previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/May_2017/05_08_2017/REGION/FAMILY"))
#------------------------------------------------------------------------------
system.time(auto_index(prep.data, "INLAND", "GENUS",
                       calc.date = "05_08_17",
                       format(Sys.time(), "%m_%d_%y"), jack.runs = 500,
                       todays_date = my.date,
                       num.itr = "50i",
                       main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output",
                       previous.subdir = "D:/ZSmith/Projects/Chessie_BIBI/Output/May_2017/05_08_2017/REGION/GENUS"))
#==============================================================================