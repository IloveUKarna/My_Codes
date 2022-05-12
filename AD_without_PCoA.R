setwd("C:/Users/USER/Documents/RStudio/AD_without")
getwd()

library(tidyverse)
library(qiime2R)
library(ggplot2)

metadata<-read_q2metadata("metadata.tsv")
shannon<-read_qza("shannon_vector.qza")
shannon_data<-shannon$data %>% rownames_to_column("SampleID")
uwunifrac<-read_qza("unweighted_unifrac_pcoa_results.qza")

uwunifrac$data$Vectors %>%
  select(SampleID, PC1, PC2) %>%
  left_join(Metadata) %>%
  left_join(shannon_data) %>%
  ggplot(aes(x=PC1, y=PC2, color=`group`)) +
  geom_point(alpha=0.9) +
  scale_color_discrete(name="Group") +
  stat_ellipse()
