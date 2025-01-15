source("./script/global.R")
source("./script/filter_grundlegend.R")

## Definiere Eingangsfilter, um später leichter wechseln zu können
filtered_data <- filtered_assistent

## Entferne alle anderen Filter, belasse nur filtered_data & table_ & plot_
rm(list = setdiff(ls(), c(ls(pattern = "^filtered_data"), grep("^(table_|plot_|data_)", ls(), value = TRUE))))

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 4.19 Bisher E-Learning genutzt ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Table ----
# Count the occurrences of TRUE and FALSE
count_true <- sum(filtered_data$`4.19` == TRUE, na.rm = TRUE)
count_false <- sum(filtered_data$`4.19` == FALSE, na.rm = TRUE)
# Total number of rows
total_rows <- nrow(filtered_data)
# Calculate percentages
percent_true <- (count_true / total_rows) * 100
percent_false <- (count_false / total_rows) * 100

# Create a new dataframe with explicit column names
table_bisher_kostenpflichtig_elearning <- data.frame(
  `Bisher kostenpflichtiges E-Learning genutzt` = c("Ja", "Nein"),
  Anzahl = c(count_true, count_false),
  Prozent = c(round(percent_true, 1), round(percent_false, 1))
)

# Vor Hinzufügen der Summenzeile Daten für den Plot kopieren
data_bisher_kostenpflichtig_elearning_plot <- table_bisher_kostenpflichtig_elearning

# Create the total row with matching column names
total_row <- data.frame(
  `Bisher kostenpflichtiges E-Learning genutzt` = "Antworten (N)",
  Anzahl = total_rows,
  Prozent = 100
)
table_bisher_kostenpflichtig_elearning <- rbind(table_bisher_kostenpflichtig_elearning, total_row)

colnames(table_bisher_kostenpflichtig_elearning)[1] <- "Bisher kostenpflichtiges E-Learning genutzt"
colnames(data_bisher_kostenpflichtig_elearning_plot)[1] <- "Bisher kostenpflichtiges\nE-Learning genutzt"

#%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Tortendiagramm erstellen
#%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Graph ----

plot_bisher_kostenpflichtig_elearning <- ggplot(data_bisher_kostenpflichtig_elearning_plot, aes(x = "", y = Prozent, fill = `Bisher kostenpflichtiges\nE-Learning genutzt`)) +
  geom_bar(stat = "identity", width = 1, color = "black") +
  coord_polar(theta = "y") +  # Convert to pie chart
  theme_void() +  # Remove background and axes
  labs(title = "Bisherige Nutzung von kostenpflichtigem E-Learning\nunter ÄrztInnen in Weiterbildung") +
  scale_fill_brewer(palette = "Pastel2") + # Color palette
  geom_text(aes(x = 1.2, label = paste(Prozent, "%")), # x = 1.2 verschiebt das Label nach aussen
            position = position_stack(vjust = 0.5),  # Position the text in the middle of each segment
            color = "black", size = 5, # Text with appropriate size
  )


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 4.20 Welches kostenpflichtige E-Learning bisher genutzt? ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Table ----

# Specify the columns of interest
columns_of_interest <- c(
  "4.20-nachschlagewerke",
  "4.20-livestreaming",
  "4.20-ondemand_vortraege",
  "4.20-podcasts",
  "4.20-ondemand_kurs",
  "4.20-sonstiges"
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
table_elearning_kostenpflichtig_welches <- data.frame(
  Antwortoption = names(filtered_subset),
  Anzahl = true_counts,
  Prozent = round(percentages, 1)
)

# Create a mapping vector
column_mapping <- c(
  "4.20-nachschlagewerke" = "Nachschlagewerke wie UpToDate oder Amboss",
  "4.20-livestreaming" = "Live-Streaming von Präsenzveranstaltungen (Kongresse, Kurse, Vorträge o. Ä.)",
  "4.20-ondemand_vortraege" = "Plattformen zum Abruf von On-Demand-Vorträgen",
  "4.20-podcasts" = "Kostenpflichtige Podcasts (z.B. Pincast o. Ä.)",
  "4.20-ondemand_kurs" = "Ganze Kursformate On-Demand (z.B. EKG-Kurs, Facharztvorbereitungskurs o. Ä.)",
  "4.20-sonstiges" = "Sonstiges"
)

# Apply the mapping
table_elearning_kostenpflichtig_welches$Antwortoption <- column_mapping[table_elearning_kostenpflichtig_welches$Antwortoption]

# Create a new table for the plot and insert the new columns
data_elearning_kostenpflichtig_welches_plot <- table_elearning_kostenpflichtig_welches
data_elearning_kostenpflichtig_welches_plot$Antwortoption_kurz <- c(
  "Nachschlagewerke\nwie Amboss oä.",
  "Präsenzveranstaltungen\nim Livestream",
  "Plattformen von\nOn-Demand-Vorträgen",
  "Kostenpflichtige\nPodcasts",
  "Vollständige Kurse\nOn-Demand",
  "Sonstiges"
)

# Order the table according to Percentages
table_elearning_kostenpflichtig_welches <- table_elearning_kostenpflichtig_welches[order(-table_elearning_kostenpflichtig_welches$Anzahl), ]
rownames(table_elearning_kostenpflichtig_welches) <- 1:nrow(table_elearning_kostenpflichtig_welches)

table_elearning_kostenpflichtig_welches <- rbind(table_elearning_kostenpflichtig_welches,
                                                 data.frame(Antwortoption = "Antworten (N)",
                                                            Anzahl = total_rows,
                                                            Prozent = 100))


#%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Horizontaler Bar-Plot
#%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Graph ----

# Fachrichtungen mit Anzahl 0 filtern
data_elearning_kostenpflichtig_welches_plot <- data_elearning_kostenpflichtig_welches_plot[data_elearning_kostenpflichtig_welches_plot$Anzahl != 0, ]

plot_elearning_kostenpflichtig_welches <- ggplot(data_elearning_kostenpflichtig_welches_plot, 
                                                 aes(x = Prozent, 
                                                     y = reorder(Antwortoption_kurz, Prozent),
                                                     fill = Antwortoption_kurz)) +
  geom_bar(stat = "identity") +
  # Two geom_text layers for conditional positioning
  geom_text(data = subset(data_elearning_kostenpflichtig_welches_plot, Prozent >= 20),
            aes(label = sprintf("%.1f%%", Prozent)),
            hjust = 1.2,
            color = "black") +  # Changed to black
  geom_text(data = subset(data_elearning_kostenpflichtig_welches_plot, Prozent < 20),
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
    title = "Welches kostenpflichtige E-Learning wurde von ÄrztInnen in Weiterbildung bereits genutzt?",
    x = "Prozent"
  ) +
  scale_x_continuous(
    limits = c(0, max(data_elearning_kostenpflichtig_welches_plot$Prozent) * 1.15),
    expand = c(0, 0)
  ) +
  scale_fill_brewer(palette = "Set3", direction = 1)


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 4.20 Finanzierung kostenpflichiges Elearning ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Table ----

# Specify the columns of interest
columns_of_interest <- c(
  "4.21-arbeitgeber",
  "4.21-selbst",
  "4.21-teilsteils",
  "4.21-unternehmen",
  "4.21-sonstiges"
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
table_finanzierung_elearning_kostenpflichtig <- data.frame(
  Antwortoption = names(filtered_subset),
  Anzahl = true_counts,
  Prozent = round(percentages, 1)
)

# Create a mapping vector
column_mapping <- c(
  "4.21-arbeitgeber" = "Vollständig durch den Arbeitgeber",
  "4.21-selbst" = "Vollständig durch mich selbst",
  "4.21-teilsteils" = "Teils durch den Arbeitgeber / Teils durch mich selbst",
  "4.21-unternehmen" = "Durch Unternehmen (z.B. Pharma, Medizinproduktehersteller)",
  "4.21-sonstiges" = "Sonstiges"
)

# Apply the mapping
table_finanzierung_elearning_kostenpflichtig$Antwortoption <- column_mapping[table_finanzierung_elearning_kostenpflichtig$Antwortoption]

# Create a new table for the plot and insert the new columns
data_finanzierung_elearning_kostenpflichtig_plot <- table_finanzierung_elearning_kostenpflichtig
data_finanzierung_elearning_kostenpflichtig_plot$Antwortoption_kurz <- c(
  "Arbeitgeber",
  "Selbst",
  "Teils / Teils",
  "Unternehmen",
  "Sonstiges"
)

# Order the table according to Percentages
table_finanzierung_elearning_kostenpflichtig <- table_finanzierung_elearning_kostenpflichtig[order(-table_finanzierung_elearning_kostenpflichtig$Anzahl), ]
rownames(table_finanzierung_elearning_kostenpflichtig) <- 1:nrow(table_finanzierung_elearning_kostenpflichtig)

table_finanzierung_elearning_kostenpflichtig <- rbind(table_finanzierung_elearning_kostenpflichtig,
                                                      data.frame(Antwortoption = "Antworten (N)",
                                                                 Anzahl = total_rows,
                                                                 Prozent = 100))


#%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Horizontaler Bar-Plot
#%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Graph ----

# Filter out rows with Anzahl 0
data_finanzierung_elearning_kostenpflichtig_plot <- 
  data_finanzierung_elearning_kostenpflichtig_plot[data_finanzierung_elearning_kostenpflichtig_plot$Anzahl != 0, ]

plot_finanzierung_elearning_kostenpflichtig <- 
  ggplot(data_finanzierung_elearning_kostenpflichtig_plot, 
         aes(x = Prozent, y = reorder(Antwortoption_kurz, Prozent), fill = Antwortoption_kurz)) +
  geom_bar(stat = "identity") +
  # Two geom_text layers for conditional positioning
  geom_text(data = subset(data_finanzierung_elearning_kostenpflichtig_plot, Prozent >= 20),
            aes(label = sprintf("%.1f%%", Prozent)),
            hjust = 1.2,
            color = "black") +  # Changed to black
  geom_text(data = subset(data_finanzierung_elearning_kostenpflichtig_plot, Prozent < 20),
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
    title = "Durch wen wurde das von ÄrztInnen in Weiterbildung\nbisher genutzte E-Learning finanziert?",
    x = "Prozent"
  ) +
  scale_x_continuous(
    limits = c(0, max(data_finanzierung_elearning_kostenpflichtig_plot$Prozent) * 1.15),
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