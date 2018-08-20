#==============================================================================
#==============================================================================
# Author: Zachary M. Smith
# Created: 04/04/2017
# Updated: 04/04/2017
# Purpose: Create maps for each year in the Chessie BIBI database.
#==============================================================================
#==============================================================================
# Set Working Directory to proper output folder.
sub.dir <- create_subdir("D:/ZSmith/Projects/Chessie_BIBI/Output", "REGION", "FAMILY")
setwd(sub.dir)
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
# General objects to make it easy to update the script.
taxon.rank <- "FAMILY"
spatial <- "REGION"
todays.date <- Sys.Date()
agg.col <- "FEATUREID"
random_event <- FALSE
catch.count <- 3
title.me <- "TEST"
#==============================================================================
# Import the appropriate data based on the specified spatial resolution (spatial),
# taxonomic resolution (taxon.rank), and the date the scores were calculated (calc.date).
final.scores <- group.me2("REGION", "FAMILY", "scored_metrics", "3_27_17_500i", final_score = TRUE)
#==============================================================================
# Establish the rating thresholds based on the Reference distribution.
# Outliers in this case reflect ONLY the Refernce distribution.
pct_sum <- percentile_summary(final.scores, "half_10", outlier = TRUE)
# Save the Reference percentile summary as a .csv.
#write.csv(pct_sum, paste(spatial, taxon.rank, todays.date, "Thresholds.csv", sep = "_"), row.names = F)
#==============================================================================
# random_events was built specifically to select only randomly sampled events
# according to the SITE_TYPE_CODE in the Chessie BIBI database.
# It appears that there are currently (3/20/17) inaccuracies associated with
# the SITE_TYPE_CODE; therefore, random_events should alwasy be set to FALSE
# until the randomly selected sampling events can be verified.
#if (random_event == TRUE) rand.events <- random_events(tab.events)
#==============================================================================
# Apply the rating scheme.
all.scores <- rate.me2(final.scores, pct_sum, taxon.rank)
#==============================================================================
# Create a new data frame with only event, station, and huc information.
huc_data <- unique(prep.data[, c("EVENT_ID", "STATION_ID", "HUC_8", "HUC_10",
                                 "HUC_12", "ACRES", "SQ_MILE")])
# Join the scores with the HUC information.
all.scores <- unique(merge(all.scores, huc_data, by = c("EVENT_ID", "STATION_ID")))
# Add the HUC12 zero back on to the beginning of the HUC12 number.
#all.scores$HUC_12 <- paste("0", all.scores$HUC_12, sep = "")
#==============================================================================
# Identify which events were considered randomly sampled based on the 
# SITE_TYPE_CODE. If random_event is NOT True, then fill column with NAs.
if (random_event == TRUE) {
  all.scores$RANDOM_SAMPLING <- ifelse(all.scores$EVENT_ID %in% rand.events$EVENT_ID, "YES", "NO") 
} else {
  all.scores$RANDOM_SAMPLING <- NA
}
#==============================================================================
# Organize and export the sampling event ratings.
all.scores <- organize_all_event_ratings(all.scores, spatial, taxon.rank,
                                         todays.date)
#==============================================================================
# Identify outliers, remove outliers, calculate percentiles without outliers for
# each Reference and Severely Degraded distributions within each bioregion.
ref_sev.pct <- ref_sev_percentiles(all.scores, spatial, taxon.rank, todays.date)
#==============================================================================
# Keep only randomly sampled sampling events.
#if (random_event == TRUE){
#  final.scores <- final.scores[final.scores$EVENT_ID %in% rand.events$EVENT_ID, ] 
#} 
#==============================================================================
# Create a new data frame containing just event, station, and HUC information.
huc.data <- unique(prep.data[, c("EVENT_ID", "STATION_ID", "HUC_8",
                                 "HUC_10", "HUC_12", "ACRES", "SQ_MILE")])
#==============================================================================
# Find the mean score by station, bioregion, and huc.
map.me <- agg_hucs_map(huc.data, final.scores)
map.me$YEAR <- format(as.Date(map.me$DATE, format =  "%m/%d/%Y"), "%Y")
#==============================================================================
#==============================================================================
# The location of the HUC12 Shapefiles.
setwd("//Pike/data/Projects/Chessie_BIBI/CBIBI_Package_July2016/GIS_July2016/ShapeFiles_Environmental")
# Import the HUC12 Shapefiles.
bioregions <- rgdal::readOGR(".", "ChesBay_WBD12_032015", stringsAsFactors = FALSE)
#==============================================================================
#==============================================================================
# Loop through by year.
# During each iteration subset by year(i).
# Plot all of the HUC12s as a visual reference.
# The sampling events are aggregated by sampling station (mean score).
# Stations are rated based on the appropriate index.
# Colors are assigned based on rating.
# The stations are plotted on to the HUC12 map.
for (i in unique(sort(map.me$YEAR))) {
  # An indication of which map is being created.
  print(paste("Start:", i))
  # Subset the dataset to only include the sampling year in the current 
  # interation(i).
  sub.map <- map.me[map.me$YEAR %in% i, ]
  # Find the mean score by station.
  map.station <- agg_station_map(sub.map, pct_sum, spatial, taxon.rank, todays.date)
  #==============================================================================
  # Transform the HUC12 Shapefiles to prepare for leaflet.
  bioregions <- sp::spTransform(bioregions, sp::CRS("+init=epsg:4326"))
  #==============================================================================
  stations.df <- merge(map.station, 
                       unique(prep.data[, c("STATION_ID", "LATITUDE",
                                            "LONGITUDE", "HUC_12")]),
                       by = "STATION_ID")
  # Specify the coordinates of each station.
  sp::coordinates(stations.df) <- ~ LONGITUDE + LATITUDE
  # Set the projection of the SpatialPointsDataFrame using the projection of 
  # the shapefile.
  sp::proj4string(stations.df) <- sp::proj4string(bioregions)
  #==============================================================================
  # Assign colors based on the Rating.
  stations.df@data$COLORS <- ifelse(stations.df@data$RATING %in% "Excellent", "darkgreen",
                                    ifelse(stations.df@data$RATING %in% "Good", "green3",
                                           ifelse(stations.df@data$RATING %in% "Fair", "yellow2",
                                                  ifelse(stations.df@data$RATING %in% "Poor", "orange2",
                                                         ifelse(stations.df@data$RATING %in% "VeryPoor", "red3",
                                                                ifelse(stations.df@data$RATING %in% c("Insufficient Samples", "TBD") |
                                                                         is.na(stations.df@data$RATING) , "white", "deeppink"))))))
  
  # Create a .png image of the mapped ratings.
  png(paste(spatial, taxon.rank, todays.date, "rating", i,  "map.png", sep = "_"),
      units = "in", res = 720,  width = 6.5, height = 9)
  # Map the HUC12 polygons.
  sp::plot(bioregions, main = i)
  # Add the sampling station points.
  points(stations.df, bg = stations.df@data$COLORS, pch = 21)
  # Finalize the png. Stop writing to this file.
  dev.off()

  # End create_map function.
}

