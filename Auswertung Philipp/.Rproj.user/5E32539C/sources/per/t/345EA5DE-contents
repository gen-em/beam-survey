source("./script/global.R")
source("./script/filter_grundlegend.R")

## Definiere Eingangsfilter, um später leichter wechseln zu können
filtered_data <- filtered_assistent

## Entferne alle anderen Filter (Übersichtlichkeit)
rm(list=setdiff(ls(), "filtered_data"))

########################################################################
####### Alter
########################################################################

## Manuelle Sortierung (>50 sonst am Anfang)
filtered_data <- filtered_data %>%
  mutate(`1.1` = factor(`1.1`, 
                        levels = c("<25","25-30", "31-35", "36-40", "41-45", "46-50", ">50"),
                        ordered = TRUE))

## Gruppieren und Prozentzahlen berechnen
table_altersverteilung <- filtered_data %>%
  group_by(`1.1`) %>%
  summarize(Anzahl = n()) %>%
  mutate(Prozent = (Anzahl / sum(Anzahl)) * 100)

## Prozentzahlen auf 1 Nachkommastelle runden
table_altersverteilung <- table_altersverteilung %>%
  mutate(Prozent = round(Prozent, 1))

## Anpassen der Spaltennamen
colnames(table_altersverteilung) <- c("Alter", "Anzahl", "Prozent")

#######################
## Histogramm erstellen
#######################
plot_altersverteilung <- ggplot(table_altersverteilung, aes(x = Alter, y = Prozent, fill = Alter)) +
  geom_bar(stat = "identity", color = "black") +
  theme_minimal() +
  labs(
    title = "Altersverteilung WeiterbildungsassistentInnen & Approbierte ÄrztInnen",
    x = "Alter",
    y = "Prozent"
  ) +
  theme(legend.position = "none") + # Remove legend since Age_Range is on the x-axis
  scale_fill_brewer(palette = "Greens", direction=1) # Color-Scale + Richtungswechsel

########################################################################
####### Weiterbildungsjahr
########################################################################

## Gruppieren und Prozentzahlen berechnen

table_weiterbildungsjahr <- filtered_data %>%
  filter(!is.na(`1.5`)) %>% # Alle NAs herausgefiltert
  group_by(`1.5`) %>%
  summarize(Anzahl = n()) %>%
  mutate(Prozent = (Anzahl / sum(Anzahl)) * 100)

## Prozentzahlen auf 1 Nachkommastelle runden
table_weiterbildungsjahr <- table_weiterbildungsjahr %>%
  mutate(Prozent = round(Prozent, 1))

## Spaltennamen anpassen
colnames(table_weiterbildungsjahr) <- c("Weiterbildungsjahr", "Anzahl", "Prozent")

#######################
## Histogramm erstellen
#######################
plot_weiterbildungsjahr <- table_weiterbildungsjahr %>%
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

########################################################################
####### Fachrichtung
########################################################################

## Relevante Zeilen auswählen
fachrichtung_cols <- filtered_data %>%
  select(`1.6-innere`, `1.6-allgemein`, `1.6-anästhesie`, `1.6-unfallchirurgie`,
         `1.6-viszeralchirurgie`, `1.6-andereschirurgisches`, `1.6-neurologie`,
         `1.6-urologie`, `1.6-sonstiges`)

## Leere Zeilen herausfiltern
fachrichtung_cols <- fachrichtung_cols %>%
  filter(rowSums(is.na(.)) < ncol(.))

## Kumulative Anzahl & Prozente berechnen
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
#######################
## Histogramm erstellen
#######################

## Fachrichtungen mit Anzahl 0 filtern
table_fachrichtung <- table_fachrichtung[table_fachrichtung$Anzahl != 0, ]

plot_fachrichtung <- ggplot(table_fachrichtung, aes(x = row.names(table_fachrichtung), y = Prozent, fill = row.names(table_fachrichtung))) +
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

########################################################################
####### Zusatzbezeichnung
########################################################################

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
  `Wollen.Zusatzbezeichnung` = c("Ja", "Nein"),  # Directly assign "Ja" and "Nein"
  Anzahl = c(count_true, count_false),
  Prozent = c(round(percent_true, 1), round(percent_false, 1))  # Round to 1 decimal place
)
colnames(table_zusatzbezeichnung)[1] <- "Wollen Zusatzbezeichnung"

#######################
## Tortendiagramm erstellen
#######################

plot_zusatzbezeichnung <- ggplot(table_zusatzbezeichnung, aes(x = "", y = Prozent, fill = `Wollen Zusatzbezeichnung`)) +
  geom_bar(stat = "identity", width = 1, color = "black") +
  coord_polar(theta = "y") +  # Convert to pie chart
  theme_void() +  # Remove background and axes
  labs(title = "Wunsch des Erwerbs der Zusatzbezeichnung unter ÄrztInnen in Weiterbildung") +
  scale_fill_brewer(palette = "Pastel2") + # Color palette
  geom_text(aes(x = 1, label = paste(Prozent, "%")), # x = 1.2 verschiebt das Label nach aussen
            position = position_stack(vjust = 0.5),  # Position the text in the middle of each segment
            color = "black", size = 5, # White text with appropriate size
  )


########################################################################
####### Muttersprache
########################################################################

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

#######################
## Tortendiagramm erstellen
#######################

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

########################################################################
####### In welchem Umfeld klinisch tätig?
########################################################################

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

# Rename the labels in the 'Arbeitsumfeld' column
table_arbeitsumfeld$Arbeitsumfeld <- gsub("<200", "Kleines Krankenhaus\n(<200 Betten)", table_arbeitsumfeld$Arbeitsumfeld)
table_arbeitsumfeld$Arbeitsumfeld <- gsub("200-500", "Mittelgroßes Krankenhaus\n(200-500 Betten)", table_arbeitsumfeld$Arbeitsumfeld)
table_arbeitsumfeld$Arbeitsumfeld <- gsub(">500", "Schwerpunkt- / Maximalversorger\n(>500 Betten)", table_arbeitsumfeld$Arbeitsumfeld)
table_arbeitsumfeld$Arbeitsumfeld <- gsub("ambulant", "Ambulant", table_arbeitsumfeld$Arbeitsumfeld)
table_arbeitsumfeld$Arbeitsumfeld <- gsub("präklinisch", "Ausschließlich\nPräklinisch", table_arbeitsumfeld$Arbeitsumfeld)
table_arbeitsumfeld$Arbeitsumfeld <- gsub("sonstiges", "Sonstiges", table_arbeitsumfeld$Arbeitsumfeld)

# Reihenfolge explizit festlegen
table_arbeitsumfeld$Arbeitsumfeld <- factor(table_arbeitsumfeld$Arbeitsumfeld, 
                                  levels = c(
                                    "Kleines Krankenhaus\n(<200 Betten)",
                                    "Mittelgroßes Krankenhaus\n(200-500 Betten)", 
                                    "Schwerpunkt- / Maximalversorger\n(>500 Betten)", 
                                    "Ambulant", 
                                    "Ausschließlich\nPräklinisch", 
                                    "Sonstiges"
                                    )
                               )

#######################
## Histogramm erstellen
#######################

## Arbeitsumfeld mit Anzahl 0 filtern
arbeitsumfeld_ohne0 <- table_arbeitsumfeld[table_arbeitsumfeld$Anzahl != 0, ]

plot_arbeitsumfeld <- ggplot(arbeitsumfeld_ohne0, aes(x = Arbeitsumfeld, y = Prozent, fill = Arbeitsumfeld)) +
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

########################################################################
####### Hauptsächlich Notaufnahme
########################################################################

# Count the occurrences of TRUE and FALSE
count_true <- sum(filtered_data$`1.11` == TRUE, na.rm = TRUE)
count_false <- sum(filtered_data$`1.11` == FALSE, na.rm = TRUE)

# Total number of rows
total_rows <- nrow(filtered_data)

# Calculate percentages
percent_true <- (count_true / total_rows) * 100
percent_false <- (count_false / total_rows) * 100

# Create a new dataframe for Hauptsächlich Notaufnahme
table_hauptsächlich_notaufnahme <- data.frame(
  `Hauptsächlich.Notaufnahme` = c("Ja", "Nein"),  # Directly assign "Ja" and "Nein"
  Anzahl = c(count_true, count_false),
  Prozent = c(round(percent_true, 1), round(percent_false, 1))  # Round to 1 decimal place
)
colnames(table_hauptsächlich_notaufnahme)[1] <- "Hauptarbeitsplatz Notaufnahme"

#######################
## Tortendiagramm erstellen
#######################

plot_hauptsächlich_notaufnahme <- ggplot(table_hauptsächlich_notaufnahme, aes(x = "", y = Prozent, fill = `Hauptarbeitsplatz Notaufnahme`)) +
  geom_bar(stat = "identity", width = 1, color = "black") +
  coord_polar(theta = "y") +  # Convert to pie chart
  theme_void() +  # Remove background and axes
  labs(title = "Hauptarbeitsort in der Notaufnahme unter ÄrztInnen in Weiterbildung") +
  scale_fill_brewer(palette = "Pastel2") + # Color palette
  geom_text(aes(x = 1, label = paste(Prozent, "%")), # x = 1.2 verschiebt das Label nach aussen
            position = position_stack(vjust = 0.5),  # Position the text in the middle of each segment
            color = "black", size = 5, # White text with appropriate size
  )


########################################################################
####### CLEANUP - Nur plot_ & table_ & filtered_data behalten
########################################################################
rm(list = setdiff(ls(), c("filtered_data", grep("^(table_|plot_)", ls(), value = TRUE))))