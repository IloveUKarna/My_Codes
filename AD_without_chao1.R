getwd()


library(qiime2R)
library(tidyverse)
library(ggplot2)

metadata<-read_q2metadata("metadata.tsv")
chao1<-read_qza("0405_chao1_vector.qza")
chao1_data<-chao1$data %>% rownames_to_column("SampleID")

Metadata<-
  metadata %>% 
  left_join(chao1_data)

head(Metadata)

ggplot(Metadata, aes(x=group, y=chao1)) +
  geom_boxplot(fill=c("blue","red","green")) +
  labs(title= 'Chao1', x= 'group', y= 'chao1', tag = "A") +
  geom_point(aes(col=group), size=3)
