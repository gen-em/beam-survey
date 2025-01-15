source("./script/global.R")
source("./script/filter_grundlegend.R")

## Definiere Eingangsfilter, um später leichter wechseln zu können
filtered_data <- filtered_assistent

## Entferne alle anderen Filter, belasse nur filtered_data & table_ & plot_
rm(list = setdiff(ls(), 
                  c(ls(pattern = "^filtered_data"), 
                    grep("^(table_|plot_|data_)", 
                         ls(), 
                         value = TRUE))))

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 2.15 Motive zur Fort- & Weiterbildung ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Table ----
# Specify the columns of interest
columns_of_interest <- c(
  "2.15-interesse", "2.15-angst_fehler", "2.15-cme", "2.15-arbeitgeber_erwartet",
  "2.15-urkunden", "2.15-umfeld", "2.15-fachlich_uptodate", "2.15-abrechnung",
  "2.15-zertifizierungen", "2.15-fortbildungsbudget_verfallen",
  "2.15-qualitaetsverbesserung", "2.15-versorgungsqualitaet"
)

# Subset the dataset to include only the specified columns
filtered_subset <- filtered_data[, columns_of_interest]

# Calculate the count of TRUE values for each column
true_counts <- colSums(filtered_subset == TRUE, na.rm = TRUE)

# Calculate the total number of rows (100% reference)
total_rows <- nrow(filtered_subset)

# Compute the percentage
percentages <- (true_counts / total_rows) * 100

# Create a data frame with the results
table_weiterbildung_motive <- data.frame(
  Antwortoption = names(filtered_subset),
  Anzahl = true_counts,
  Prozent = round(percentages,1)
)

# Create a mapping vector
column_mapping <- c(
  "2.15-interesse" = "Ich habe persönliches / berufliches Interesse an den Inhalten",
  "2.15-angst_fehler" = "Ich habe Angst Fehler zu machen",
  "2.15-cme" = "Ich sammle CME Punkte",
  "2.15-arbeitgeber_erwartet" = "Mein Arbeitgeber erwartet oder fordert es von mir",
  "2.15-urkunden" = "Ich möchte Zertifikate / Urkunden erlangen welche ich präsentieren / ausstellen kann",
  "2.15-umfeld" = "Weil mein Umfeld sich regelmäßig fortbildet",
  "2.15-fachlich_uptodate" = "Weil ich fachlich auf dem neuesten Stand bleiben möchte",
  "2.15-abrechnung" = "Ich brauche Fortbildungen als Voraussetzung zur Abrechnung bestimmter Leistungen",
  "2.15-zertifizierungen" = "Ich brauche Fortbildungen als Voraussetzung für Zertifizierungen (der Praxis/Abteilung oä.)",
  "2.15-fortbildungsbudget_verfallen" = "Mein Fortbildungsbudget soll nicht verfallen",
  "2.15-qualitaetsverbesserung" = "Ich möchte die Qualität meiner Arbeit verbessern",
  "2.15-versorgungsqualitaet" = "Ich möchte die Versorgungsqualität meiner PatientInnen verbessern"
)

# Apply the mapping
table_weiterbildung_motive$Antwortoption <- column_mapping[table_weiterbildung_motive$Antwortoption]

# Create a new table for the plot and insert the new columns
data_weiterbildung_motive_plot <- table_weiterbildung_motive

data_weiterbildung_motive_plot$Antwortoption_kurz <- c(
  "Persönliches oder\nBerufliches Interesse",
  "Angst vor Fehlern",
  "Sammeln von CME Punkten",
  "Arbeitgeber erwartet es",
  "Präsentierbare Zertifikate",
  "Umfeld bildet sich fort",
  "Fachlich auf dem\nneuesten Stand bleiben",
  "Zur Abrechnung\nvon Leistungen",
  "Voraussetzung\nfür Zertifizierungen",
  "Fortbildungsbudget\nsoll nicht verfallen",
  "Qualität der eigenen\nArbeit verbessern",
  "Versorgungsqualität\nvon Patienten verbessern"
)

# Create a total row
total_row <- data.frame(
  Antwortoption = "Antworten (N)",
  Anzahl = total_rows,
  Prozent = 100
)

# Order the table according to Percentages
table_weiterbildung_motive <- table_weiterbildung_motive[order(-table_weiterbildung_motive$Anzahl), ]
rownames(table_weiterbildung_motive) <- 1:nrow(table_weiterbildung_motive)

# Combine the original table with the total row
table_weiterbildung_motive <- rbind(table_weiterbildung_motive, total_row)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Horizontaler Bar-Plot
#%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Graph ----

plot_weiterbildung_motive <- ggplot(data_weiterbildung_motive_plot, 
       aes(x = Prozent, 
           y = reorder(Antwortoption_kurz, Prozent),
           fill = Antwortoption_kurz)) +
  geom_bar(stat = "identity") +
  # Two geom_text layers for conditional positioning
  geom_text(data = subset(data_weiterbildung_motive_plot, Prozent >= 20),
            aes(label = sprintf("%.1f%%", Prozent)),
            hjust = 1.2,
            color = "black") +  # Changed to black
  geom_text(data = subset(data_weiterbildung_motive_plot, Prozent < 20),
            aes(label = sprintf("%.1f%%", Prozent)),
            hjust = -0.2,
            color = "black") +
  theme_minimal() +
  theme(
    axis.title.y = element_blank(),
    panel.grid.major.y = element_blank(),
    axis.text = element_text(size = 10),
    legend.position = "none"
  ) +
  labs(
    title = "Motive zur Fort- & Weiterbildung",
    x = "Prozent"
  ) +
  scale_x_continuous(
    limits = c(0, max(data_weiterbildung_motive_plot$Prozent) * 1.15),
    expand = c(0, 0)
  ) +
  scale_fill_brewer(palette = "Set3", direction = 1)



#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# CLEANUP - Nur plot_ & table_ & filtered_data behalten
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rm(list = setdiff(ls(), 
                  c(ls(pattern = "^filtered_data"), 
                    grep("^(table_|plot_|data_)", 
                         ls(), 
                         value = TRUE))))