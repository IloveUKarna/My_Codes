getwd()

SVs <- read_qza("0310_deblur_table.qza")
taxonomy <- read_qza("0501_taxonomy.qza")

SV <- read_qza("0310_deblur_table.qza")$data
Taxonomy <- read_qza("0501_taxonomy.qza")$data

SVs_1 <- apply(SV, 2, function(x) x/sum(x)*100)

SVToPlot <-  
  data.frame(MeanAbundance=rowMeans(SVs_1)) %>%
  rownames_to_column("Feature.ID") %>%
  arrange(desc(MeanAbundance)) %>% 
  top_n(25, MeanAbundance) %>%
  pull(Feature.ID)


SV %>%
  as.data.frame() %>%
  rownames_to_column("Feature.ID") %>%
  gather(-Feature.ID, key="SampleID", value="Abundance") %>%
  mutate(Feature.ID=if_else(Feature.ID %in% SVToPlot,  Feature.ID, "Remainder")) %>%
  group_by(SampleID, Feature.ID) %>%
  summarize(Abundance=sum(Abundance)) %>%
  left_join(metadata) %>%
  mutate(NormAbundance=log10(Abundance+0.01)) %>%
  left_join(Taxonomy) %>%
  mutate(Feature=paste(Feature.ID, Taxon)) %>%
  mutate(Feature=gsub("[kpcofgs]__", "", Feature)) %>%
  ggplot(aes(x=SampleID, y=Feature, fill=NormAbundance)) +
  geom_tile() +
  facet_grid(~`group`, scales="free_x") +
  theme_q2r() +
  theme(axis.text.x=element_text(angle=45, hjust=1)) +
  scale_fill_viridis_c(name="log10(% Abundance)")
