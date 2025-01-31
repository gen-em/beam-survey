# Load dependencies
source("./script/config/global.R")
source("./script/config/filter_grundlegend.R")
source("./script/config/graph-include.R")
source("./script/config/cleanup.R")

## Welches KOLLEKTIV soll ausgewertet werden? 
## Filter in filter_grundlegend definiert
## Nur LABEL_KOLLEKTIV muss entsprechend angepasst werden
## Mögliche Werte
## LABEL_KOLLEKTIV =  alle
##                    studentinnen
##                    assistentinnen
##                    fachaerztinnen
##                    oberaerztinnen
##                    chefaerztinnen
##                    weiterbildende

LABEL_KOLLEKTIV <- "assistentinnen"
filtered_data <- get(paste0("filtered_", LABEL_KOLLEKTIV))
NAME_KOLLEKTIV <- get(paste0("name_", LABEL_KOLLEKTIV))

## Sollen die Plots geprintet werden? TRUE = ja, FALSE = nein
PRINT_PLOTS = TRUE

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# 3.16 Bisher E-Learning genutzt - Pie-Chart ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "3_16"
LABEL_FRAGE <- "bisher_elearning_genutzt"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Anteil der %s, welche bereits E-Learning genutzt haben", NAME_KOLLEKTIV
)

## Titel der angezeigten Labels (kurz, knackig)
LABEL_TITLE <- "Bereits E-Learning genutzt"

## Welche Column?
COLUMN_OF_INTEREST <- "3.16"

## Benennung / Assoziation der Antwortoptionen
VALUE_MAPPING <- c(
  "TRUE" = "Ja",
  "FALSE" = "Nein"
)

## Brewer Palette für Farbgebung
BREWER_PALETTE <- "Pastel2"


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Generate Outputs
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

create_pie_chart(
  filtered_data = filtered_data, 
  column_of_interest = COLUMN_OF_INTEREST, 
  NAME_FRAGE = NAME_FRAGE,
  LABEL_TITLE = LABEL_TITLE,
  VALUE_MAPPING = VALUE_MAPPING,
  PLOT_TITLE = PLOT_TITLE,
  BREWER_PALETTE = BREWER_PALETTE
)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# 3.17 Welches E-Learning bisher genutzt - Histogramm ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "3_17"
LABEL_FRAGE <- "welches_elearning_bisher"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Welche Arten von E-Learning haben %s bisher genutzt?", NAME_KOLLEKTIV
)

## Anzeige von "Antworten N=XXX" auf dem Graph
ANNOTATE_ANZAHL = TRUE

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

short_column_names <- c(
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

brewer_palette <- "Set3"


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Generate Outputs
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

create_horizontal_bar_plot_percentages(
  filtered_data, 
  columns_of_interest, 
  column_mapping, 
  short_column_names, 
  NAME_FRAGE, 
  PLOT_TITLE,
  ANNOTATE_ANZAHL,
  brewer_palette
)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# 3.18 Engeräte zur bisherigen Nutzung von E-Learning - Histogramm ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "3_18"
LABEL_FRAGE <- "engeraete_elearning_bisher"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Welche Endgeräte haben %s bisher für E-Learning genutzt?", NAME_KOLLEKTIV
)

## Anzeige von "Antworten N=XXX" auf dem Graph
ANNOTATE_ANZAHL = TRUE

columns_of_interest <- c(
  "3.18-smartphone",
  "3.18-tablet",
  "3.18-computer"
)

column_mapping <- c(
  "3.18-smartphone" = "Smartphone",
  "3.18-tablet" = "Tablet",
  "3.18-computer" = "Laptop / Desktop-PC"
)

short_column_names <- c(
  "Smartphone",
  "Tablet",
  "Laptop / Desktop-PC"
)

brewer_palette <- "Set3"


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Generate Outputs
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

create_horizontal_bar_plot_percentages(
  filtered_data, 
  columns_of_interest, 
  column_mapping, 
  short_column_names, 
  NAME_FRAGE, 
  PLOT_TITLE,
  ANNOTATE_ANZAHL,
  brewer_palette
)


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# PRINT'em ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (PRINT_PLOTS) {
  print(get(paste0("plot_3_16_", LABEL_KOLLEKTIV, "_bisher_elearning_genutzt")))
  print(get(paste0("plot_3_17_", LABEL_KOLLEKTIV, "_welches_elearning_bisher")))
  print(get(paste0("plot_3_18_", LABEL_KOLLEKTIV, "_engeraete_elearning_bisher")))
}


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# Clean up ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cleanup_workspace()