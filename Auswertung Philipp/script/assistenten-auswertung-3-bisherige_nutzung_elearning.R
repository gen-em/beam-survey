source("./script/global.R")
source("./script/filter_grundlegend.R")

## Definiere Eingangsfilter, um später leichter wechseln zu können
filtered_data_2 <- filtered_assistent

## Entferne alle anderen Filter, belasse nur filtered_data & table_ & plot_
rm(list = setdiff(ls(), c(ls(pattern = "^filtered_data"), grep("^(table_|plot_|data_)", ls(), value = TRUE))))



########################################################################
####### 3.16 Bisher E-Learning genutzt
########################################################################

# Count the occurrences of TRUE and FALSE
count_true <- sum(filtered_data_1$`3.16` == TRUE, na.rm = TRUE)
count_false <- sum(filtered_data_1$`3.16` == FALSE, na.rm = TRUE)
# Total number of rows
total_rows <- nrow(filtered_data_1)
# Calculate percentages
percent_true <- (count_true / total_rows) * 100
percent_false <- (count_false / total_rows) * 100

# Create a new dataframe with explicit column names
table_bisher_elearning <- data.frame(
  `Bisher E-Learning genutzt` = c("Ja", "Nein"),
  Anzahl = c(count_true, count_false),
  Prozent = c(round(percent_true, 1), round(percent_false, 1))
)

# Create the total row with matching column names
total_row <- data.frame(
  `Bisher E-Learning genutzt` = "Antworten (N)",
  Anzahl = total_rows,
  Prozent = 100
)
# Vor Hinzufügen der Summenzeile Daten für den Plot kopieren
data_bisher_elearning_plot <- table_bisher_elearning

# Combine the dataframes
table_bisher_elearning <- rbind(table_bisher_elearning, total_row)

colnames(table_bisher_elearning)[1] <- "Bisher E-Learning genutzt"
colnames(data_bisher_elearning_plot)[1] <- "Bisher E-Learning genutzt"

#######################
## Tortendiagramm erstellen
#######################

plot_bisher_elearning <- ggplot(data_bisher_elearning_plot, aes(x = "", y = Prozent, fill = `Bisher E-Learning genutzt`)) +
  geom_bar(stat = "identity", width = 1, color = "black") +
  coord_polar(theta = "y") +  # Convert to pie chart
  theme_void() +  # Remove background and axes
  labs(title = "Bisherige Nutzung von E-Learning unter ÄrztInnen in Weiterbildung") +
  scale_fill_brewer(palette = "Pastel2") + # Color palette
  geom_text(aes(x = 1.2, label = paste(Prozent, "%")), # x = 1.2 verschiebt das Label nach aussen
            position = position_stack(vjust = 0.5),  # Position the text in the middle of each segment
            color = "black", size = 5, # Text with appropriate size
  )


######################################################################## 
####### 3.17 Welches E-Learning bisher genutzt? 
######################################################################## 

# Specify the columns of interest
columns_of_interest <- c(
  "3.17-informationsplattformen",
  "3.17-fachzeitschriften_online",
  "3.17-nachschlagewerke",
  "3.17-youtube",
  "3.17-blogs",
  "3.17-sozialemedien",
  "3.17-streaming_praesenzveranstaltung",
  "3.17-webinar",
  "3.18-ondemand_vortraege",
  "3.17-ondemand_kurse",
  "3.17-sonstiges"
)

# Subset the dataset to include only the specified columns
filtered_subset <- filtered_data_2[, columns_of_interest]

# Calculate the count of TRUE values for each column
true_counts <- colSums(filtered_subset == TRUE, na.rm = TRUE)

# Calculate the total number of rows (100% reference)
total_rows <- nrow(filtered_subset)

# Compute the percentage
percentages <- (true_counts / total_rows) * 100

# Create a data frame with the results
table_elearning_bisher_welches <- data.frame(
  Antwortoption = names(filtered_subset),
  Anzahl = true_counts,
  Prozent = round(percentages, 1)
)

# Create a mapping vector
column_mapping <- c(
  "3.17-informationsplattformen" = "Medizinische Informationsplattformen (Ärzteblatt, Medscape, DocCheck etc.)",
  "3.17-fachzeitschriften_online" = "Online-Versionen von Fachzeitschriften",
  "3.17-nachschlagewerke" = "Online-Nachschlagewerke (Amboss, UpToDate, DocCheck etc.)",
  "3.17-youtube" = "YouTube",
  "3.17-blogs" = "Online Blogs",
  "3.17-sozialemedien" = "Soziale Medien (X/Twitter, Instagram, TikTok etc.)",
  "3.17-streaming_praesenzveranstaltung" = "Streaming von Präsenzveranstaltungen (Virtuelle Kongressteilnahme o.Ä.)",
  "3.17-webinar" = "Webinare (Live-Veranstaltungen, nur online stattfindend)",
  "3.18-ondemand_vortraege" = "On-Demand - einzelne Vorträge",
  "3.17-ondemand_kurse" = "On-Demand - ganze Kurse (EKG Kurs, Facharztvorbereitungskurs, Amboss CME-Kurse etc.)",
  "3.17-sonstiges" = "Sonstige (gerne im Textfeld näher beschreiben)"
)

# Apply the mapping
table_elearning_bisher_welches$Antwortoption <- column_mapping[table_elearning_bisher_welches$Antwortoption]

# Create a new table for the plot and insert the new columns
data_elearning_bisher_welches_plot <- table_elearning_bisher_welches
data_elearning_bisher_welches_plot$Antwortoption_kurz <- c(
  "Medizinische\nInformationsplattformen",
  "Onlineversionen von\nFachzeitschriften",
  "Online\nNachschlagewerke",
  "YouTube",
  "Online Blogs",
  "Soziale Medien",
  "Streaming von\nPräsenzveranstaltungen",
  "Webinare",
  "On-Demand Vorträge",
  "On-Demand Kurse",
  "Sonstiges"
)

# Order the table according to Percentages
table_elearning_bisher_welches <- table_elearning_bisher_welches[order(-table_elearning_bisher_welches$Anzahl), ]
rownames(table_elearning_bisher_welches) <- 1:nrow(table_elearning_bisher_welches)

table_elearning_bisher_welches <- rbind(table_elearning_bisher_welches,
                                        data.frame(Antwortoption = "Antworten (N)",
                                                   Anzahl = total_rows,
                                                   Prozent = 100))
#########################
## Horizontaler Bar-Plot
#########################

plot_elearning_bisher_welches <- ggplot(data_elearning_bisher_welches_plot, 
                                    aes(x = Prozent, 
                                        y = reorder(Antwortoption_kurz, Prozent),
                                        fill = Antwortoption_kurz)) +
  geom_bar(stat = "identity") +
  # Two geom_text layers for conditional positioning
  geom_text(data = subset(data_elearning_bisher_welches_plot, Prozent >= 20),
            aes(label = sprintf("%.1f%%", Prozent)),
            hjust = 1.2,
            color = "black") +  # Changed to black
  geom_text(data = subset(data_elearning_bisher_welches_plot, Prozent < 20),
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
    title = "Welches E-Learning wurde von ÄrztInnen in Weiterbildung bereits genutzt?",
    x = "Prozent"
  ) +
  scale_x_continuous(
    limits = c(0, max(data_elearning_bisher_welches_plot$Prozent) * 1.15),
    expand = c(0, 0)
  ) +
  scale_fill_brewer(palette = "Set3", direction = 1)

######################################################################## 
####### 3.18 E-Learning auf welchen Endgeräten bisher genutzt? 
######################################################################## 

# Specify the columns of interest
columns_of_interest <- c(
  "3.18-smartphone",
  "3.18-tablet",
  "3.18-computer"
)

# Subset the dataset to include only the specified columns
filtered_subset <- filtered_data_2[, columns_of_interest]

# Calculate the count of TRUE values for each column
true_counts <- colSums(filtered_subset == TRUE, na.rm = TRUE)

# Calculate the total number of rows (100% reference)
total_rows <- nrow(filtered_subset)

# Compute the percentage
percentages <- (true_counts / total_rows) * 100

# Create a data frame with the results
table_elearning_endgeraete <- data.frame(
  Antwortoption = names(filtered_subset),
  Anzahl = true_counts,
  Prozent = round(percentages, 1)
)

# Create a mapping vector
column_mapping <- c(
  "3.18-smartphone" = "Smartphone",
  "3.18-tablet" = "Tablet",
  "3.18-computer" = "Laptop / Desktop-PC"
)

# Apply the mapping
table_elearning_endgeraete$Antwortoption <- column_mapping[table_elearning_endgeraete$Antwortoption]

# Create a new table for the plot and insert the new columns
data_elearning_endgeraete_plot <- table_elearning_endgeraete
data_elearning_endgeraete_plot$Antwortoption_kurz <- c(
  "Smartphone",
  "Tablet",
  "Laptop / Desktop-PC"
)

# Order the table according to Percentages
table_elearning_endgeraete <- table_elearning_endgeraete[order(-table_elearning_endgeraete$Anzahl), ]
rownames(table_elearning_endgeraete) <- 1:nrow(table_elearning_endgeraete)

# Reihe mit Summen einfügen
table_elearning_endgeraete <- rbind(table_elearning_endgeraete, 
                                    data.frame(Antwortoption = "Antworten (N)", 
                                               Anzahl = total_rows,
                                               Prozent = 100))

#########################
## Horizontaler Bar-Plot
#########################

plot_elearning_endgeraete <- ggplot(data_elearning_endgeraete_plot, 
                                    aes(x = Prozent, 
                                        y = reorder(Antwortoption_kurz, Prozent),
                                        fill = Antwortoption_kurz)) +
  geom_bar(stat = "identity", width = 0.75) +  # Adjusted width to 0.5  # Two geom_text layers for conditional positioning
  geom_text(data = subset(data_elearning_endgeraete_plot, Prozent >= 20),
            aes(label = sprintf("%.1f%%", Prozent)),
            hjust = 1.2,
            color = "black") +
  geom_text(data = subset(data_elearning_endgeraete_plot, Prozent < 20),
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
    title = "Welche Endgeräte wurden von ÄrztInnen in Weiterbildung\nbisher für E-Learning genutzt?",
    x = "Prozent"
  ) +
  scale_x_continuous(
    limits = c(0, max(data_elearning_endgeraete_plot$Prozent) * 1.15),
    expand = c(0, 0)
  ) +
  scale_fill_brewer(palette = "Set3", direction = 1)

print(plot_elearning_endgeraete)

########################################################################
####### CLEANUP - Nur plot_ & table_ & filtered_data_2 behalten
########################################################################
rm(list = setdiff(ls(), c(ls(pattern = "^filtered_data"), grep("^(table_|plot_|data_)", ls(), value = TRUE))))