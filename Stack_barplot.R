library(phyloseq)
library(qiime2R)
library(tidyverse)
library(vegan)
library(picante)
library(cowplot)
library(DESeq2)
library(ggplot2)


setwd("C:/Users/USER/Documents/RStudio/AD_without")


###change working directory>more>go to working directory> r studio
###manually move all files (in next command) to r studio

phy <- qza_to_phyloseq (features = "0302_table.qza", "0301_taxonomy_silva.qza", tree = "rooted_tree.qza", metadata = "metadata.tsv")

###manually move file shannon_vector.qza to r studio
###to see new file created "phy" go to environment tab

shannon <- read_qza("shannon_vector.qza")
rich <- plot_richness(phy)

###highlight only rich and press command enter

nsamples(phy)
sample_names(phy)
OTUtable<-otu_table(phy)
OTUtable<-as.data.frame(OTUtable)
write.csv(OTUtable,"OTU_table.csv")
rich

###pick up at line 199 in tutorial###

phy_rel_abund <- transform_sample_counts(phy, function(x) {x / sum(x)})
plot_bar(phy_rel_abund, fill = "Phylum") +
  geom_bar(aes(color = Phylum, fill = Phylum), stat = "identity", position = "stack") +
  labs(x = "", y="Relative abundance") +
  theme_q2r() +
  ggtitle("Relative abundance stack bar plot") +
  theme(axis.title = element_text(color="black", face="bold", size=10)) +
  theme(plot.title = element_text(color="black", face = "bold", size =12, hjust = 0.5))
