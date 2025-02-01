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
PRINT_PLOTS = FALSE

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# 4.19 Bisher kostenpflichtiges E-Learning genutzt - Pie-Chart ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "4_19"
LABEL_FRAGE <- "bisher_elearning_genutzt_kostenpflichtig"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Anteil der %s, welche bereits \nkostenpflichtiges E-Learning genutzt haben", NAME_KOLLEKTIV
)

## Titel der angezeigten Labels (kurz, knackig)
LABEL_TITLE <- "Bereits kostenpflichtiges \nE-Learning genutzt"

## Welche Column?
COLUMN_OF_INTEREST <- "4.19"

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
# 4.20 Welches kostenpflichtige E-Learning bisher genutzt? - HIstogramm ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "4_20"
LABEL_FRAGE <- "welches_elearning_bisher_kostenpflichtig"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Welche Arten von kostenpflichtigem E-Learning haben \n%s bisher genutzt?", NAME_KOLLEKTIV
)

## Anzeige von "Antworten N=XXX" auf dem Graph
ANNOTATE_ANZAHL = TRUE

columns_of_interest <- c(
  "4.20-nachschlagewerke",
  "4.20-livestreaming",
  "4.20-ondemand_vortraege",
  "4.20-podcasts",
  "4.20-ondemand_kurs",
  "4.20-sonstiges"
)

column_mapping <- c(
  "4.20-nachschlagewerke" = "Nachschlagewerke wie UpToDate oder Amboss",
  "4.20-livestreaming" = "Live-Streaming von Präsenzveranstaltungen (Kongresse, Kurse, Vorträge o. Ä.)",
  "4.20-ondemand_vortraege" = "Plattformen zum Abruf von On-Demand-Vorträgen",
  "4.20-podcasts" = "Kostenpflichtige Podcasts (z.B. Pincast o. Ä.)",
  "4.20-ondemand_kurs" = "Ganze Kursformate On-Demand (z.B. EKG-Kurs, Facharztvorbereitungskurs o. Ä.)",
  "4.20-sonstiges" = "Sonstiges"
)

short_column_names <- c(
  "Nachschlagewerke\nwie Amboss oä.",
  "Präsenzveranstaltungen\nim Livestream",
  "Plattformen von\nOn-Demand-Vorträgen",
  "Kostenpflichtige\nPodcasts",
  "Vollständige Kurse\nOn-Demand",
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
# 4.21 Finanzierung kostenpflichtiges E-Learning? - Histogramm ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "4_21"
LABEL_FRAGE <- "finanzierung_elearning"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Wie wurde das von %s \nbisher genutzte E-Learning finanziert?", NAME_KOLLEKTIV
)

## Anzeige von "Antworten N=XXX" auf dem Graph
ANNOTATE_ANZAHL = TRUE

columns_of_interest <- c(
  "4.21-arbeitgeber",
  "4.21-selbst",
  "4.21-teilsteils",
  "4.21-unternehmen",
  "4.21-sonstiges"
)

column_mapping <- c(
  "4.21-arbeitgeber" = "Vollständig durch den Arbeitgeber",
  "4.21-selbst" = "Vollständig durch mich selbst",
  "4.21-teilsteils" = "Teils durch den Arbeitgeber / Teils durch mich selbst",
  "4.21-unternehmen" = "Durch Unternehmen (z.B. Pharma, Medizinproduktehersteller)",
  "4.21-sonstiges" = "Sonstiges"
)

short_column_names <- c(
  "Arbeitgeber",
  "Selbst",
  "Teils / Teils",
  "Unternehmen",
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
# PRINT'em ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (PRINT_PLOTS) {
  print(get(paste0("plot_4_19_", LABEL_KOLLEKTIV, "_bisher_elearning_genutzt_kostenpflichtig")))
  print(get(paste0("plot_4_20_", LABEL_KOLLEKTIV, "_welches_elearning_bisher_kostenpflichtig")))
  print(get(paste0("plot_4_21_", LABEL_KOLLEKTIV, "_finanzierung_elearning")))
}


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# Clean up ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#cleanup_workspace()