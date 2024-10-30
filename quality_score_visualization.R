data_ncbi <- read.csv(file = "data/read_length_quality/NCBI_read_statistics.csv")

# Daten für die Kurve erstellen und daraus einen Dataframe
all_phred_scores <- 0:40
all_error_probabilities <- phred_to_probability(all_phred_scores)
data_all <- data.frame(Phred=all_phred_scores, ErrorProbability=all_error_probabilities)

# manual y labels
y_breaks <- c(1, 0.1, 0.01, 0.001, 0.0001)
y_labels <- c("100%", "10%", "1%", "0.1%", "0.01%")

# Calculate mean for each iso
isos <- unique(data_ncbi$ISO)
mean_quality_scores <- sapply(isos, function(iso) {
  mean(data_ncbi$Mean_Quality_Score[data_ncbi$ISO == iso])
})
mean_quality_probabilities <- phred_to_probability(mean_quality_scores)

LAB <- c("2015: AcMNPV-WP10 (SRR1118212)\nIllumina Genome Analyzer IIx",
         "2024: BmNPV-Th2 (SRR25338386)\nIllumina NextSeq500", 
         "2024: HearNPV-IIPR05 (SRR21146807)\nIllumina HiSeq2500", 
         "2024: OpbuNPV (SRR27473752)\nIllumina MiSeq", 
         "2024: BmNPV-Th2 (SRR27030578)\nONT Rapid Ligation Kit", 
         "2023: PaviNPV-Gz05 (SRR17312069)\nONT Ligation Kit"
)

data_means <- data.frame(ISO = isos, 
                         Mean_Quality_Score = mean_quality_scores, 
                         Mean_Quality_Probability = mean_quality_probabilities,
                         LAB)

data_labels <- c("2024: BmNPV-Th2 (SRR27030578)\nONT Rapid Ligation Kit", 
                 "2023: PaviNPV-Gz05 (SRR17312069)\nONT Ligation Kit",
                 "2015: AcMNPV-WP10 (SRR1118212)\nIllumina Genome Analyzer IIx",
                 "2024: BmNPV-Th2 (SRR25338386)\nIllumina NextSeq500", 
                 "2024: HearNPV-IIPR05 (SRR21146807)\nIllumina HiSeq2500", 
                 "2024: OpbuNPV (SRR27473752)\nIllumina MiSeq"
)

data_means$LAB <- factor(data_means$LAB, levels = c(data_labels))
custom_colors <- brewer.pal(length(LAB), "Purples")

x_offsets <- c(4, -4, 2, 3.5, -4.5)
y_offsets <- c(0.002, -0.00055, 0.0005, 0.09, -0.02)

#plot
pQP <- ggplot() +
  geom_line(data = data_all, aes(x = Phred, y = 1-ErrorProbability), color="darkblue") +
  geom_point(data = data_means, aes(x = Mean_Quality_Score, y = 1 - Mean_Quality_Probability, fill = LAB), 
             shape=22, size=4, colour="black", stroke = 0.2) +
  geom_segment(aes(x = 0, y = 0.01, xend = 20, yend = 0.01), 
               linetype = "dotted", color = "black") + #horizontal line
  geom_segment(aes(x = 20, y = 0, xend = 20, yend = 0.01), 
               linetype = "dotted", color = "black") + # #vertical line
  scale_y_continuous(expand = c(0, 0), limits = c(-0.03, 1), breaks = c(0, 0.25, 0.5, 0.75, 1), labels = c("0%", "25%", "50%", "75%", "100%")) +
  scale_x_continuous(expand = c(0,0)) +
  scale_fill_manual(values = custom_colors) +
  labs(x = "Phred Quality Score (Q)", y = "Error Probability (%)") +
  theme_bw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = "right",
        legend.title = element_blank(),
        legend.text = element_text(size = 8),
        legend.key.height = unit(1.5, "lines"),
        axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) 

# Plots speichern
f <- 2

ggsave(plot = pQP, filename = "output/ncbi_stats/phred_vs_probability.png",
       units = "cm", 
       dpi = 300, 
       width = 9 * f, 
       height = 5 * f)


#plot with log transformed y axis
pQP_log <- ggplot() +
  geom_line(data = data_all, aes(x = Phred, y = 1-ErrorProbability), color="darkblue") +
  geom_point(data = data_means, aes(x = Mean_Quality_Score, y = 1 - Mean_Quality_Probability, fill = LAB), 
             shape=22, size=4, colour="black", stroke = 0.2) +
  geom_segment(aes(x = 20, y = 0.01, xend = 0, yend = 0.01), 
               linetype = "dotted", color = "black") + #HL
  geom_segment(aes(x = 20, y = 0.01, xend = 20, yend = 0.0001), 
               linetype = "dotted", color = "black") + #VL
  scale_y_log10(expand = c(0,0), breaks = y_breaks, labels = y_labels) +
  scale_x_continuous(expand = c(0,0)) +
  scale_fill_manual(values = custom_colors) +
  labs(x="Phred Quality Score (Q)",
       y="Error Probability (%)") +
  theme_bw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = "right",
        legend.title = element_blank(),
        legend.text = element_text(size = 8),
        legend.key.height = unit(1.5, "lines"),
        axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) 


# Plots speichern
f <- 2

ggsave(plot = pQP_log, filename = "output/ncbi_stats/phred vs probability_log.png", 
       units = "cm", 
       dpi = 300, 
       width = 9 * f, 
       height = 5 * f)



######

pQP <- pQP + theme(legend.position = "none")
combined_plot <- (pQP + pQP_log) + plot_annotation(tag_levels = 'A')

# Anzeige des kombinierten Plots
print(combined_plot)

f <- 1.2
# Speichern des kombinierten Plots als PDF
file_name <- "output/ncbi_stats/phred_vs_probability_combined.png"
ggsave(file_name, combined_plot, width = 8*f, height = 3*f)