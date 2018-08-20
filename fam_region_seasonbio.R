#==============================================================================
#==============================================================================
# Author: Zachary M. Smith
# Created: 5/18/17
# Updated: 5/18/17
# Purpose: Plot subsets of data to understand index performance
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
# Set Working Directory to proper output folder.
setwd("D:/ZSmith/Projects/Chessie_BIBI/Output/May_2017/05_08_2017/REGION/FAMILY")
#==============================================================================
my.df <- read.csv("REGION_FAMILY_05_11_17_All_Event_Ratings.csv", stringsAsFactors = FALSE)
names(my.df)[names(my.df) %in% "BIOREGION"] <- "REGION"
my.df$CATEGORY <- ifelse(my.df$CATEGORY %in% "SEV", "DEG", my.df$CATEGORY)
my.df$EGF <- ifelse(my.df$RATING %in% c("Excellent", "Good", "Fair"),
                    "TRUE", "FALSE")
table(my.df$RATING, my.df$EGF)
#==============================================================================
merged.df <- merge(my.df, unique(prep.data[, c("EVENT_ID", "SAMPLE_NUMBER",
                                               "ICPRB_BIOREGION_ID")]),
                   by = c("EVENT_ID", "SAMPLE_NUMBER"))
names(merged.df)[names(merged.df) %in% "ICPRB_BIOREGION_ID"] <- "BIOREGION"
#==============================================================================
ref.df <- merged.df[merged.df$CATEGORY %in% c("REF"), ]
ref.df$DATE <- as.Date(ref.df$DATE, "%m/%d/%Y")
ref.df$MONTH <- as.numeric(format(ref.df$DATE, "%m"))
ref.df$SEASON <- ifelse(ref.df$MONTH <= 6, "Winter/Spring",
                        ifelse(ref.df$MONTH > 6 , "Summer/Fall", "ERROR"))
ref.df$BIO_SEASON <- paste(ref.df$BIOREGION, ref.df$SEASON, sep = "_")
#==============================================================================
bio.season.vec <- sapply(unique(ref.df$BIO_SEASON), function(bio.x) {
  sub.df <- ref.df[ref.df$BIO_SEASON %in% bio.x, ]
  count.vec <- nrow(sub.df[sub.df$EGF == TRUE, ]) 
  pct.vec <- round(count.vec / nrow(sub.df) * 100, 1)
  pct.vec <- sprintf("%.1f", pct.vec)
  
  final.vec <- paste0(pct.vec, "% (n = ", count.vec, ")")
  
  return(final.vec)
})

pct.df <- data.frame(VALUE = bio.season.vec)
pct.df$BIO_SEASON <- row.names(pct.df)
pct.df$BIOREGION <- gsub("_.*", "", pct.df$BIO_SEASON)
pct.df$SEASON <- gsub(".*_", "", pct.df$BIO_SEASON)
pct.df <- pct.df[, !names(pct.df) %in% "BIO_SEASON"]

pct.df <- tidyr::spread(pct.df, SEASON, VALUE)
#==============================================================================
egf.df <- ref.df[ref.df$EGF == TRUE, ]
egf.df$BIO_SEASON <- factor(egf.df$BIO_SEASON)
wilcox.list <- lapply(unique(egf.df$BIOREGION), function(bio.x) {
  sub.df <- egf.df[egf.df$BIOREGION %in% bio.x, ]
  non.par <- wilcox.test(FINAL_SCORE ~ SEASON, data = sub.df)
  final.df <- data.frame(BIOREGION = bio.x)
  final.df$P_VALUE <- non.par$p.value
  final.df$TEST_STAT <- non.par$statistic
  return(final.df)
})

wilcox.df <- do.call(rbind, wilcox.list)

final.df <- merge(pct.df, wilcox.df, by = "BIOREGION")
final.df$P_VALUE <- round(final.df$P_VALUE, 3)
final.df$P_VALUE <- ifelse(final.df$P_VALUE < 0.001, "< 0.001", sprintf("%.3f", final.df$P_VALUE))

write.csv(final.df, "fam_region_bioseason_ref_min.csv", row.names = FALSE)

library(ggplot2)
library(gridExtra)
plot.list <- lapply(unique(egf.df$BIOREGION), function(bio.x) {
  sub.df <- egf.df[egf.df$BIOREGION %in% bio.x, ]
  ggplot(sub.df, aes(BIO_SEASON, FINAL_SCORE, color = SEASON)) + 
    geom_boxplot(outlier.alpha = 0) +
    geom_jitter(alpha = 0.2, width = 0.3) +
    theme(legend.position = "none") +
    scale_y_continuous(limits = c(0, 105))
})
gridExtra::grid.arrange(plot.list[[1]], plot.list[[2]], plot.list[[3]],
                        plot.list[[4]], plot.list[[5]], plot.list[[6]])

gridExtra::grid.arrange(plot.list[[7]], plot.list[[8]], plot.list[[9]],
                        plot.list[[10]], plot.list[[11]], plot.list[[12]])


test <- data.frame(table(ref.df$AGENCY_CODE, ref.df$BIO_SEASON))
test <- test[test$Freq > 0, ]
sub.ref <- ref.df[ref.df$EGF == TRUE, ]
test2 <- data.frame(table(sub.ref$AGENCY_CODE, sub.ref$BIO_SEASON))
test2 <- test2[test2$Freq > 0, ]

test3 <- merge(test, test2, by = c("Var1", "Var2"))
test3$FRACTION <- paste0(test3$Freq.y, "/", test3$Freq.x)
test3$BIOREGION <- gsub("_.*", "", test3$Var2)
test3$SEASON <- gsub(".*_", "", test3$Var2)
final.test <- test3[, c("Var1", "BIOREGION", "SEASON", "FRACTION")]
final.test <- final.test[order(final.test$BIOREGION, final.test$SEASON), ]
names(final.test)[1] <- "AGENCY_CODE"
write.csv(final.test, "fam_region_bioseason_ref_min.csv", row.names = F)
