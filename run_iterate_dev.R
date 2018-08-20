#==============================================================================
#==============================================================================
# Author: Zachary M. Smith
# Created: 2016
# Updated: 4/10/2017
# Purpose: Import and prepate Chessie BIBI data.
#==============================================================================
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
# Basin
#==============================================================================
system.time(iterate_dev(prep.data, "BASIN", "ORDER", runs = 50,
                        unique.station = TRUE, standard_count = TRUE))
gc()
system.time(iterate_dev(prep.data, "BASIN", "FAMILY", runs = 50,
                        unique.station = TRUE, standard_count = TRUE))
gc()
system.time(iterate_dev(prep.data, "BASIN", "GENUS", runs = 50,
                        unique.station = TRUE, standard_count = TRUE))
gc()
#==============================================================================
# Region
#==============================================================================
# Coast
system.time(iterate_dev(prep.data, "COAST", "ORDER", runs = 50,
                        unique.station = TRUE, standard_count = TRUE))
gc()

system.time(iterate_dev(prep.data, "COAST", "FAMILY", runs = 50,
                        unique.station = TRUE, standard_count = TRUE))
gc()

system.time(iterate_dev(prep.data, "COAST", "GENUS", runs = 50,
                        unique.station = TRUE, standard_count = TRUE))
gc()

system.time(iterate_dev(prep.data, "INLAND", "ORDER", runs = 50,
                        unique.station = TRUE, standard_count = TRUE))
gc()

system.time(iterate_dev(prep.data, "INLAND", "FAMILY", runs = 50,
                        unique.station = TRUE, standard_count = TRUE))
gc()

system.time(iterate_dev(prep.data, "INLAND", "GENUS", runs = 50,
                        unique.station = TRUE, standard_count = TRUE))
gc()
#==============================================================================
# Bioregion
#==============================================================================
prep.data <- prep.data[order(prep.data$ICPRB_BIOREGION_ID), ]
system.time(iterate_dev(prep.data, "BIOREGION", "ORDER", runs = 50,
                        unique.station = TRUE, standard_count = TRUE))
gc()
system.time(iterate_dev(prep.data, "BIOREGION", "FAMILY", runs = 50,
                        unique.station = TRUE, standard_count = TRUE))
gc()
system.time(iterate_dev(prep.data, "BIOREGION", "GENUS", runs = 50,
                        unique.station = TRUE, standard_count = TRUE))
gc()
#==============================================================================
# TEST

all.data <- prep.data
all.data <- all.data[all.data$ICPRB_BIOREGION_ID %in% "MAC", ]
index.res <- "BIOREGION"
taxon.rank <- "FAMILY"
runs = 50
unique.station = TRUE
standard_count = TRUE
main.dir = "D:/ZSmith/Projects/Chessie_BIBI/Output"


mac.df <- prep.data[prep.data$ICPRB_BIOREGION_ID %in% c("SEP", "NRV", "PIED"), ]
system.time(iterate_dev(mac.df, "BIOREGION", "FAMILY", runs = 50,
                        unique.station = TRUE, standard_count = TRUE))


test.metrics <- BIBI::specific_metrics(master, all.data,
                                           taxa.rank =  taxon.rank,
                                           rare = "DIV_RARE", pct_un = 10,
                                           bibi.standard = TRUE,
                                           metrics.vec = "ALL")

master2 <- clean_taxa(master)
#==============================================================================
# Calculate the percent of each taxon in the data base by Sequencing through each taxon rank
if(taxon.rank %in% "ORDER") ranks.list <- c("SUBORDER", "FAMILY", "SUBFAMILY", "TRIBE", "GENUS", "SPECIES")
if(taxon.rank %in% "FAMILY") ranks.list <- c("SUBFAMILY", "TRIBE", "GENUS", "SPECIES")
if(taxon.rank %in% "GENUS") ranks.list <- c("SPECIES")
master2[, ranks.list] <- NA
bio.data.seq <- seq_pct_taxa(all.data, master2)

any(is.na(bio.data.seq))


wide.df <- BIBI::wide(mac.df, "FAMILY")

becks(wide.df, "FAMILY")
