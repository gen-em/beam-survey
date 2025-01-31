# Einstellungen ----
source("./script/config/global.R")
source("./script/config/filter_grundlegend.R")
source("./script/config/graph-include.R")

# Definiere Eingangsfilter, um später leichter wechseln zu können
filtered_data <- filtered_assistent

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# 1 - Basisdaten ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1.1 Alter ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### Table ----

# Manuelle Sortierung (>50 sonst am Anfang)
filtered_data <- filtered_data %>%
  mutate(`1.1` = factor(`1.1`, 
                        levels = c("<25","25-30", "31-35", "36-40", "41-45", "46-50", ">50"),
                        ordered = TRUE))

# Gruppieren und Prozentzahlen berechnen
table_altersverteilung <- filtered_data %>%
  group_by(`1.1`) %>%
  summarize(Anzahl = n()) %>%
  mutate(Prozent = (Anzahl / sum(Anzahl)) * 100)

# Prozentzahlen auf 1 Nachkommastelle runden
table_altersverteilung <- table_altersverteilung %>%
  mutate(Prozent = round(Prozent, 1))

# Anpassen der Spaltennamen
colnames(table_altersverteilung) <- c("Alter", "Anzahl", "Prozent")

# Kopieren für den Graph
data_altersverteilung_plot <- table_altersverteilung

# Create a total row
total_row <- data.frame(
  Alter = "Antworten (N)",
  Anzahl = sum(table_altersverteilung$Anzahl),
  Prozent = 100
)

# Combine the original table with the total row
table_altersverteilung <- rbind(table_altersverteilung, total_row)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Histogramm erstellen
#%%%%%%%%%%%%%%%%%%%%%%%%%%%
### Graph ----

plot_altersverteilung <- ggplot(data_altersverteilung_plot, aes(x = Alter, y = Prozent, fill = Alter)) +
  geom_bar(stat = "identity", color = "black") +
  theme_minimal() +
  labs(
    title = "Altersverteilung WeiterbildungsassistentInnen & Approbierte ÄrztInnen",
    x = "Alter",
    y = "Prozent"
  ) +
  theme(legend.position = "none") + # Remove legend since Age_Range is on the x-axis
  scale_fill_brewer(palette = "Greens", direction=1) # Color-Scale + Richtungswechsel

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1.5 Weiterbildungsjahr ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### Table ----

# Gruppieren und Prozentzahlen berechnen

table_weiterbildungsjahr <- filtered_data %>%
  filter(!is.na(`1.5`)) %>% # Alle NAs herausgefiltert
  group_by(`1.5`) %>%
  summarize(Anzahl = n()) %>%
  mutate(Prozent = (Anzahl / sum(Anzahl)) * 100)

# Prozentzahlen auf 1 Nachkommastelle runden
table_weiterbildungsjahr <- table_weiterbildungsjahr %>%
  mutate(Prozent = round(Prozent, 1))

# Spaltennamen anpassen
colnames(table_weiterbildungsjahr) <- c("Weiterbildungsjahr", "Anzahl", "Prozent")

# Kopieren der Tabelle für den Graph
data_weiterbildungsjahr_plot <- table_weiterbildungsjahr

# Create a total row
total_row <- data.frame(
  Weiterbildungsjahr = "Antworten (N)",
  Anzahl = sum(table_weiterbildungsjahr$Anzahl),
  Prozent = 100
)

# Combine the original table with the total row
table_weiterbildungsjahr <- rbind(table_weiterbildungsjahr, total_row)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Histogramm erstellen
#%%%%%%%%%%%%%%%%%%%%%%%%%%%
### Graph ----

plot_weiterbildungsjahr <- data_weiterbildungsjahr_plot %>%
  mutate(Weiterbildungsjahr = factor(Weiterbildungsjahr, 
                                     levels = sort(unique(Weiterbildungsjahr)))) %>%
  ggplot(aes(x = Weiterbildungsjahr, y = Prozent, fill = Weiterbildungsjahr)) +
  geom_bar(stat = "identity", color = "black") +
  theme_minimal() +
  labs(
    title = "Verteilung der Weiterbildungsjahre WeiterbildungsassistentInnen & Approbierte ÄrztInnen",
    x = "Weiterbildungsjahr",
    y = "Prozent"
  ) +
  theme(legend.position = "none") + # Remove legend since Age_Range is on the x-axis
  scale_fill_brewer(palette = "Purples", direction = 1) # Color-Scale + Richtungswechsel

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1.6 Fachrichtung ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### Table ----

# Relevante Zeilen auswählen
fachrichtung_cols <- filtered_data %>%
  select(`1.6-innere`, `1.6-allgemein`, `1.6-anaesthesie`, `1.6-unfallchirurgie`,
         `1.6-viszeralchirurgie`, `1.6-andereschirurgisches`, `1.6-neurologie`,
         `1.6-urologie`, `1.6-sonstiges`)

# Leere Zeilen herausfiltern
fachrichtung_cols <- fachrichtung_cols %>%
  filter(rowSums(is.na(.)) < ncol(.))

# Kumulative Anzahl & Prozente berechnen
fachrichtung_kumulativ <- colSums(fachrichtung_cols == TRUE, na.rm = TRUE)
total_rows <- nrow(fachrichtung_cols)
percentages <- (fachrichtung_kumulativ / total_rows) * 100

# In Dataframe überführen
table_fachrichtung <- data.frame(
  Anzahl = fachrichtung_kumulativ,
  Prozent = round(percentages, 1)  # Round to 1 decimal place
)
rownames(table_fachrichtung) <- c("Innere Medizin", 
                                  "Allgemeinmedizin", 
                                  "Anästhesie", 
                                  "Unfallchirurgie", 
                                  "Viszeralchirurgie",
                                  "Anderes chir. Fachgebiet",
                                  "Neurologie",
                                  "Urologie",
                                  "Sonstiges"
)

# Kopie der Tabelle für den Graph
data_fachrichtung_plot <- table_fachrichtung

# Create a total row
total_row <- data.frame(
  Anzahl = total_rows,
  Prozent = 100
)
rownames(total_row) <- "Antworten (N)"

# Combine the original table with the total row
table_fachrichtung <- rbind(table_fachrichtung, total_row)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Histogramm erstellen
#%%%%%%%%%%%%%%%%%%%%%%%%%%%
### Graph ----

# Fachrichtungen mit Anzahl 0 filtern
data_fachrichtung_plot <- data_fachrichtung_plot[data_fachrichtung_plot$Anzahl != 0, ]

plot_fachrichtung <- ggplot(data_fachrichtung_plot, aes(x = row.names(data_fachrichtung_plot), y = Prozent, fill = row.names(data_fachrichtung_plot))) +
  geom_bar(stat = "identity", color = "black") +
  theme_minimal() +
  labs(
    title = "Angestrebte Facharztbezeichnung von ÄrztInnen in Weiterbildung",
    x = "Fachrichtung",
    y = "Prozent"
  ) +
  
  # Remove legend since Age_Range is on the x-axis & Rotate x-axis labels by 45 degrees
  theme(legend.position = "none", 
        axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 0.5)) + 
  
  # Farbpalettenauswahl
  scale_fill_brewer(palette = "Set2", direction=1) # Color-Scale + Richtungswechsel

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1.8 Zusatzbezeichnung ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### Table ----

# Count the occurrences of TRUE and FALSE
count_true <- sum(filtered_data$`1.8` == TRUE, na.rm = TRUE)
count_false <- sum(filtered_data$`1.8` == FALSE, na.rm = TRUE)

# Total number of rows
total_rows <- nrow(filtered_data)

# Calculate percentages
percent_true <- (count_true / total_rows) * 100
percent_false <- (count_false / total_rows) * 100

# Create a new dataframe for zusatzbezeichnung
table_zusatzbezeichnung <- data.frame(
  Wollen.Zusatzbezeichnung = c("Ja", "Nein"),  # Directly assign "Ja" and "Nein"
  Anzahl = c(count_true, count_false),
  Prozent = c(round(percent_true, 1), round(percent_false, 1))  # Round to 1 decimal place
)
colnames(table_zusatzbezeichnung)[1] <- "Wollen Zusatzbezeichnung"

# Kopieren für den Graphen
data_zusatzbezeichnung_plot <- table_zusatzbezeichnung

# Add a total row
total_row <- data.frame(
  `Wollen Zusatzbezeichnung` = "Antworten (N)",
  Anzahl = total_rows,
  Prozent = 100
)

# Combine the original table with the total row
colnames(total_row) <- colnames(table_zusatzbezeichnung)
table_zusatzbezeichnung <- rbind(table_zusatzbezeichnung, total_row)


#%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Tortendiagramm erstellen
#%%%%%%%%%%%%%%%%%%%%%%%%%%%
### Graph ----

plot_zusatzbezeichnung <- ggplot(data_zusatzbezeichnung_plot, aes(x = "", y = Prozent, fill = `Wollen Zusatzbezeichnung`)) +
  geom_bar(stat = "identity", width = 1, color = "black") +
  coord_polar(theta = "y") +  # Convert to pie chart
  theme_void() +  # Remove background and axes
  labs(title = "Wunsch des Erwerbs der Zusatzbezeichnung unter ÄrztInnen in Weiterbildung") +
  scale_fill_brewer(palette = "Pastel2") + # Color palette
  geom_text(aes(x = 1, label = paste(Prozent, "%")), # x = 1.2 verschiebt das Label nach aussen
            position = position_stack(vjust = 0.5),  # Position the text in the middle of each segment
            color = "black", size = 5, # White text with appropriate size
  )
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1.10 In welchem Umfeld klinisch tätig? ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### Table ----

# Define the order of categories
categories <- c("<200", "200-500", ">500", "ambulant", "präklinisch", "sonstiges")

# Count the occurrences of each category
count_values <- table(factor(filtered_data$`1.10`, levels = categories))

# Total number of rows
total_rows <- nrow(filtered_data)

# Calculate percentages
percent_values <- (count_values / total_rows) * 100

# Create a new dataframe for arbeitsumfeld with only the required columns
table_arbeitsumfeld <- data.frame(
  Arbeitsumfeld = names(count_values),  # Use the names of the count_values vector
  Anzahl = as.vector(count_values),  # Convert count_values to a vector
  Prozent = as.vector(round(percent_values, 1))  # Convert percent_values to a vector and round
)

# Für den Graphen kopieren
data_arbeitsumfeld_plot <- table_arbeitsumfeld

# Rename the labels in the 'Arbeitsumfeld' column
table_arbeitsumfeld$Arbeitsumfeld <- gsub("<200", "Kleines Krankenhaus (<200 Betten)", table_arbeitsumfeld$Arbeitsumfeld)
table_arbeitsumfeld$Arbeitsumfeld <- gsub("200-500", "Mittelgroßes Krankenhaus (200-500 Betten)", table_arbeitsumfeld$Arbeitsumfeld)
table_arbeitsumfeld$Arbeitsumfeld <- gsub(">500", "Schwerpunkt- / Maximalversorger (>500 Betten)", table_arbeitsumfeld$Arbeitsumfeld)
table_arbeitsumfeld$Arbeitsumfeld <- gsub("ambulant", "Ambulant", table_arbeitsumfeld$Arbeitsumfeld)
table_arbeitsumfeld$Arbeitsumfeld <- gsub("präklinisch", "Ausschließlich Präklinisch", table_arbeitsumfeld$Arbeitsumfeld)
table_arbeitsumfeld$Arbeitsumfeld <- gsub("sonstiges", "Sonstiges", table_arbeitsumfeld$Arbeitsumfeld)

# Reihenfolge explizit festlegen
table_arbeitsumfeld$Arbeitsumfeld <- factor(table_arbeitsumfeld$Arbeitsumfeld, 
                                            levels = c(
                                              "Kleines Krankenhaus (<200 Betten)",
                                              "Mittelgroßes Krankenhaus (200-500 Betten)", 
                                              "Schwerpunkt- / Maximalversorger (>500 Betten)", 
                                              "Ambulant", 
                                              "Ausschließlich Präklinisch", 
                                              "Sonstiges"
                                            )
)



# Add a total row
total_row <- data.frame(
  Arbeitsumfeld = "Antworten (N)",
  Anzahl = total_rows,
  Prozent = 100
)

# Combine the original table with the total row
table_arbeitsumfeld <- rbind(table_arbeitsumfeld, total_row)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Histogramm erstellen
#%%%%%%%%%%%%%%%%%%%%%%%%%%%
### Graph ----

# Zeilenumbrüche einfügen und Daten Faktorisieren / Reihenfolge festlegen
data_arbeitsumfeld_plot$Arbeitsumfeld <- gsub("<200", "Kleines Krankenhaus\n(<200 Betten)", data_arbeitsumfeld_plot$Arbeitsumfeld)
data_arbeitsumfeld_plot$Arbeitsumfeld <- gsub("200-500", "Mittelgroßes Krankenhaus\n(200-500 Betten)", data_arbeitsumfeld_plot$Arbeitsumfeld)
data_arbeitsumfeld_plot$Arbeitsumfeld <- gsub(">500", "Schwerpunkt- / Maximalversorger\n(>500 Betten)", data_arbeitsumfeld_plot$Arbeitsumfeld)
data_arbeitsumfeld_plot$Arbeitsumfeld <- gsub("ambulant", "Ambulant", data_arbeitsumfeld_plot$Arbeitsumfeld)
data_arbeitsumfeld_plot$Arbeitsumfeld <- gsub("präklinisch", "Ausschließlich\nPräklinisch", data_arbeitsumfeld_plot$Arbeitsumfeld)
data_arbeitsumfeld_plot$Arbeitsumfeld <- gsub("sonstiges", "Sonstiges", data_arbeitsumfeld_plot$Arbeitsumfeld)

data_arbeitsumfeld_plot$Arbeitsumfeld <- factor(data_arbeitsumfeld_plot$Arbeitsumfeld, 
                                                levels = c(
                                                  "Kleines Krankenhaus\n(<200 Betten)",
                                                  "Mittelgroßes Krankenhaus\n(200-500 Betten)", 
                                                  "Schwerpunkt- / Maximalversorger\n(>500 Betten)", 
                                                  "Ambulant", 
                                                  "Ausschließlich\nPräklinisch", 
                                                  "Sonstiges"
                                                )
)

# Arbeitsumfeld mit Anzahl 0 filtern
data_arbeitsumfeld_plot <- data_arbeitsumfeld_plot[data_arbeitsumfeld_plot$Anzahl != 0, ]

plot_arbeitsumfeld <- ggplot(data_arbeitsumfeld_plot, aes(x = Arbeitsumfeld, y = Prozent, fill = Arbeitsumfeld)) +
  geom_bar(stat = "identity", color = "black") +
  theme_minimal() +
  labs(
    title = "Arbeitsumfeld der ÄrztInnen in Weiterbildung",
    x = "Arbeitsumfeld",
    y = "Prozent"
  ) +
  
  # Remove legend since Arbeitsumfeld is on the x-axis & Rotate x-axis labels by 45 degrees
  theme(legend.position = "none", 
        axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 0.5)) + 
  
  # Farbpalettenauswahl
  scale_fill_brewer(palette = "Set2", direction=1) # Color-Scale + Richtungswechsel

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1.11 Hauptsächlich Notaufnahme ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### Table ----

# Count the occurrences of TRUE and FALSE
count_true <- sum(filtered_data$`1.11` == TRUE, na.rm = TRUE)
count_false <- sum(filtered_data$`1.11` == FALSE, na.rm = TRUE)

# Total number of rows
total_rows <- nrow(filtered_data)

# Calculate percentages
percent_true <- (count_true / total_rows) * 100
percent_false <- (count_false / total_rows) * 100

# Create a new dataframe for Hauptsächlich Notaufnahme
table_hauptsaechlich_notaufnahme <- data.frame(
  `Hauptsaechlich.Notaufnahme` = c("Ja", "Nein"),  # Directly assign "Ja" and "Nein"
  Anzahl = c(count_true, count_false),
  Prozent = c(round(percent_true, 1), round(percent_false, 1))  # Round to 1 decimal place
)
colnames(table_hauptsaechlich_notaufnahme)[1] <- "Hauptarbeitsplatz Notaufnahme"

# Kopieren für den Graphen
data_hauptsaechlich_notaufnahme <- table_hauptsaechlich_notaufnahme

# Add a total row
total_row <- data.frame(
  `Hauptarbeitsplatz Notaufnahme` = "Antworten (N)",
  Anzahl = total_rows,
  Prozent = 100
)

# Combine the original table with the total row
colnames(total_row) <- colnames(table_hauptsaechlich_notaufnahme)
table_hauptsaechlich_notaufnahme <- rbind(table_hauptsaechlich_notaufnahme, total_row)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Tortendiagramm erstellen
#%%%%%%%%%%%%%%%%%%%%%%%%%%%
### Graph ----

plot_hauptsaechlich_notaufnahme <- ggplot(data_hauptsaechlich_notaufnahme, aes(x = "", y = Prozent, fill = `Hauptarbeitsplatz Notaufnahme`)) +
  geom_bar(stat = "identity", width = 1, color = "black") +
  coord_polar(theta = "y") +  # Convert to pie chart
  theme_void() +  # Remove background and axes
  labs(title = "Hauptarbeitsort in der Notaufnahme unter ÄrztInnen in Weiterbildung") +
  scale_fill_brewer(palette = "Pastel2") + # Color palette
  geom_text(aes(x = 1, label = paste(Prozent, "%")), # x = 1.2 verschiebt das Label nach aussen
            position = position_stack(vjust = 0.5),  # Position the text in the middle of each segment
            color = "black", size = 5, # White text with appropriate size
  )

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1.12 Muttersprache ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### Table ----

# Count the occurrences of TRUE and FALSE
count_true <- sum(filtered_data$`1.12` == TRUE, na.rm = TRUE)
count_false <- sum(filtered_data$`1.12` == FALSE, na.rm = TRUE)

# Total number of rows
total_rows <- nrow(filtered_data)

# Calculate percentages
percent_true <- (count_true / total_rows) * 100
percent_false <- (count_false / total_rows) * 100

# Create a new dataframe for muttersprache
table_muttersprache <- data.frame(
  Muttersprache = c("TRUE", "FALSE"),
  Anzahl = c(count_true, count_false),
  Prozent = c(round(percent_true, 1), round(percent_false, 1))  # Round to 1 decimal place
)

# Rename TRUE to "Deutsch" and FALSE to "Andere"
table_muttersprache$Muttersprache <- gsub("TRUE", "Deutsch", table_muttersprache$Muttersprache)
table_muttersprache$Muttersprache <- gsub("FALSE", "Andere", table_muttersprache$Muttersprache)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Tortendiagramm erstellen
#%%%%%%%%%%%%%%%%%%%%%%%%%%%
### Graph ----

plot_muttersprache <- ggplot(table_muttersprache, aes(x = "", y = Prozent, fill = Muttersprache)) +
  geom_bar(stat = "identity", width = 1, color = "black") +
  coord_polar(theta = "y") +  # Convert to pie chart
  theme_void() +  # Remove background and axes
  labs(title = "Muttersprache der ÄrztInnen in Weiterbildung") +
  scale_fill_brewer(palette = "Pastel2") + # Color palette
  geom_text(aes(x = 1.2, label = paste(Prozent, "%")), # x = 1.2 verschiebt das Label nach aussen
            position = position_stack(vjust = 0.5),  # Position the text in the middle of each segment
            color = "black", size = 5, # White text with appropriate size
  )

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# 2 - Motive zur Fort- & Weiterbildung ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2.15 Motive zur Fort- & Weiterbildung ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### Table ----
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
### Graph ----

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

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# 3 - Bisherige Nutzung von E-Learning ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 3.16 Bisher E-Learning genutzt ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### Table ----

# Count the occurrences of TRUE and FALSE
count_true <- sum(filtered_data$`3.16` == TRUE, na.rm = TRUE)
count_false <- sum(filtered_data$`3.16` == FALSE, na.rm = TRUE)
# Total number of rows
total_rows <- nrow(filtered_data)
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

#%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Tortendiagramm erstellen
#%%%%%%%%%%%%%%%%%%%%%%%%%%%
### Graph ----
plot_bisher_elearning <- 
  ggplot(data_bisher_elearning_plot, aes(x = "", y = Prozent, fill = `Bisher E-Learning genutzt`)) +
  geom_bar(stat = "identity", width = 1, color = "black") +
  coord_polar(theta = "y") +  # Convert to pie chart
  theme_void() +  # Remove background and axes
  labs(title = "Bisherige Nutzung von E-Learning unter ÄrztInnen in Weiterbildung") +
  scale_fill_brewer(palette = "Pastel2") + # Color palette
  geom_text(aes(x = 1.2, label = paste(Prozent, "%")), # x = 1.2 verschiebt das Label nach aussen
            position = position_stack(vjust = 0.5),  # Position the text in the middle of each segment
            color = "black", size = 5, # Text with appropriate size
  )


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
## 3.17 Welches E-Learning bisher genutzt?  ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
### Table ----

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
filtered_subset <- filtered_data[, columns_of_interest]

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
  "3.17-informationsplattformen" = 
    "Medizinische Informationsplattformen (Ärzteblatt, Medscape, DocCheck etc.)",
  "3.17-fachzeitschriften_online" = 
    "Online-Versionen von Fachzeitschriften",
  "3.17-nachschlagewerke" = 
    "Online-Nachschlagewerke (Amboss, UpToDate, DocCheck etc.)",
  "3.17-youtube" = 
    "YouTube",
  "3.17-blogs" = 
    "Online Blogs",
  "3.17-sozialemedien" = 
    "Soziale Medien (X/Twitter, Instagram, TikTok etc.)",
  "3.17-streaming_praesenzveranstaltung" = 
    "Streaming von Präsenzveranstaltungen (Virtuelle Kongressteilnahme o.Ä.)",
  "3.17-webinar" = 
    "Webinare (Live-Veranstaltungen, nur online stattfindend)",
  "3.18-ondemand_vortraege" = 
    "On-Demand - einzelne Vorträge",
  "3.17-ondemand_kurse" = 
    "On-Demand - ganze Kurse (EKG Kurs, Facharztvorbereitungskurs, Amboss CME-Kurse etc.)",
  "3.17-sonstiges" = 
    "Sonstige"
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
table_elearning_bisher_welches <- 
  table_elearning_bisher_welches[order(-table_elearning_bisher_welches$Anzahl), ]

rownames(table_elearning_bisher_welches) <- 1:nrow(table_elearning_bisher_welches)

table_elearning_bisher_welches <- rbind(table_elearning_bisher_welches,
                                        data.frame(Antwortoption = "Antworten (N)",
                                                   Anzahl = total_rows,
                                                   Prozent = 100))
#%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Horizontaler Bar-Plot
#%%%%%%%%%%%%%%%%%%%%%%%%%%%
### Graph ----

# Fachrichtungen mit Anzahl 0 filtern
data_elearning_bisher_welches_plot <- 
  data_elearning_bisher_welches_plot[data_elearning_bisher_welches_plot$Anzahl != 0, ]

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

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
## 3.18 E-Learning auf welchen Endgeräten bisher genutzt?  ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
### Table ----

# Specify the columns of interest
columns_of_interest <- c(
  "3.18-smartphone",
  "3.18-tablet",
  "3.18-computer"
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

#%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Horizontaler Bar-Plot
#%%%%%%%%%%%%%%%%%%%%%%%%%%%
### Graph ----
plot_elearning_endgeraete <- ggplot(data_elearning_endgeraete_plot, 
                                    aes(x = Prozent, 
                                        y = reorder(Antwortoption_kurz, Prozent),
                                        fill = Antwortoption_kurz)) +
  geom_bar(stat = "identity", width = 0.75) +  # Adjusted width
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

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# 4 - Bisherige Finanzierung von E-Learning ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 4.19 Bisher E-Learning genutzt ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### Table ----
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
### Graph ----

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


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 4.20 Welches kostenpflichtige E-Learning bisher genutzt? ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### Table ----

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
### Graph ----

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


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 4.21 Finanzierung kostenpflichiges Elearning ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### Table ----

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
### Graph ----

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

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# 5 - Ideales E-Learning ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##5.22 Können sie sich vorstellen E-Learning in Zukunft zu nutzen? ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### Table ----

# Count the occurrences of TRUE and FALSE
count_true <- sum(filtered_data$`5.22` == TRUE, na.rm = TRUE)
count_false <- sum(filtered_data$`5.22` == FALSE, na.rm = TRUE)
# Total number of rows
total_rows <- nrow(filtered_data)
# Calculate percentages
percent_true <- (count_true / total_rows) * 100
percent_false <- (count_false / total_rows) * 100

# Create a new dataframe with explicit column names
table_zukuenftig_elearning <- data.frame(
  `Würden in Zukunft E-Learning nutzen` = c("Ja", "Nein"),
  Anzahl = c(count_true, count_false),
  Prozent = c(round(percent_true, 1), round(percent_false, 1))
)

# Create the total row with matching column names
total_row <- data.frame(
  `Würden in Zukunft E-Learning nutzen` = "Antworten (N)",
  Anzahl = total_rows,
  Prozent = 100
)
# Vor Hinzufügen der Summenzeile Daten für den Plot kopieren
data_zukuenftig_elearning_plot <- table_zukuenftig_elearning

# Combine the dataframes
table_zukuenftig_elearning <- rbind(table_zukuenftig_elearning, total_row)

colnames(table_zukuenftig_elearning)[1] <- "Würden in Zukunft E-Learning nutzen"
colnames(data_zukuenftig_elearning_plot)[1] <- "Würden in Zukunft E-Learning nutzen"

#%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Tortendiagramm erstellen
#%%%%%%%%%%%%%%%%%%%%%%%%%%%
### Graph ----
plot_zukuenftig_elearning <- 
  ggplot(data_zukuenftig_elearning_plot, aes(x = "", y = Prozent, fill = `Würden in Zukunft E-Learning nutzen`)) +
  geom_bar(stat = "identity", width = 1, color = "black") +
  coord_polar(theta = "y") +  # Convert to pie chart
  theme_void() +  # Remove background and axes
  labs(title = "Bisherige Nutzung von E-Learning unter ÄrztInnen in Weiterbildung") +
  scale_fill_brewer(palette = "Pastel2") + # Color palette
  geom_text(aes(x = 1.2, label = paste(Prozent, "%")), # x = 1.2 verschiebt das Label nach aussen
            position = position_stack(vjust = 0.5),  # Position the text in the middle of each segment
            color = "black", size = 5, # Text with appropriate size
  )