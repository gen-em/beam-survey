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

LABEL_KOLLEKTIV <- "jung_assistentinnen"
filtered_data <- get(paste0("filtered_", LABEL_KOLLEKTIV))
NAME_KOLLEKTIV <- get(paste0("name_", LABEL_KOLLEKTIV))

## Sollen die Plots geprintet werden? TRUE = ja, FALSE = nein
PRINT_PLOTS = TRUE

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# 1.1 Alter - Histogramm ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "1_01"
LABEL_FRAGE <- "alter"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
  )

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Altersverteilung \n%s", NAME_KOLLEKTIV
  )

## Welche Spalte wird ausgewertet?
COLUMN_OF_INTEREST <- "1.1"

## Brewer Color Palette für Graph
BREWER_PALETTE <- "Greens"


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Generate Outputs
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

create_age_distribution_plot(
  filtered_data = filtered_data,
  column_of_interest = COLUMN_OF_INTEREST,
  NAME_FRAGE = NAME_FRAGE,
  PLOT_TITLE = PLOT_TITLE,
  BREWER_PALETTE = BREWER_PALETTE
)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# 1.2 Weiterbildungsjahr - Histogramm ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

FRAGE_NUMMER <- "1_05"
LABEL_FRAGE <- "weiterbildungsjahr"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Verteilung der Weiterbildungsjahre \n%s", NAME_KOLLEKTIV
)

## Welche Spalte wird ausgewertet?
COLUMN_OF_INTEREST <- "1.5"

## Brewer Color Palette für Graph
BREWER_PALETTE <- "Purples"

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Generate Outputs
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

create_training_year_distribution_plot(
  filtered_data = filtered_data,
  column_of_interest = COLUMN_OF_INTEREST,
  NAME_FRAGE = NAME_FRAGE,
  PLOT_TITLE = PLOT_TITLE,
  BREWER_PALETTE = BREWER_PALETTE
)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# 1.6 Fachrichtung - Histogramm ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Define Configuration
FRAGE_NUMMER <- "1_06"
LABEL_FRAGE <- "fachrichtung"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf("Angestrebte Facharztbezeichnung \n%s", NAME_KOLLEKTIV)

## Farbe des Graphen festlegen
BREWER_PALETTE <- "Set2"

## Specify columns of interest
COLS_OF_INTEREST <- c("1.6-innere", 
                      "1.6-allgemein", 
                      "1.6-anaesthesie", 
                      "1.6-unfallchirurgie",
                      "1.6-viszeralchirurgie", 
                      "1.6-andereschirurgisches", 
                      "1.6-neurologie",
                      "1.6-urologie", 
                      "1.6-sonstiges")

# Define row names
ROW_NAMES <- c("Innere Medizin", 
               "Allgemeinmedizin", 
               "Anästhesie", 
               "Unfallchirurgie", 
               "Viszeralchirurgie", 
               "Anderes chir. Fachgebiet", 
               "Neurologie", 
               "Urologie", 
               "Sonstiges")

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Generate Outputs
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

create_specialty_distribution_plot(
  filtered_data = filtered_data,
  cols_of_interest = COLS_OF_INTEREST,
  row_names = ROW_NAMES,
  NAME_FRAGE = NAME_FRAGE,
  PLOT_TITLE = PLOT_TITLE,
  BREWER_PALETTE = BREWER_PALETTE
)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# 1.8 Zusatzbezeichnung - Pie-Chart ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "1_08"
LABEL_FRAGE <- "zusatzbezeichnung"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Wollen %s \ndie Zusatzbezeichnung Klinische Akut- und Notfallmedizin erwerben?", NAME_KOLLEKTIV
)

## Titel der angezeigten Labels (kurz, knackig)
LABEL_TITLE <- "Wollen Zusatzbezeichnung"

## Welche Column?
COLUMN_OF_INTEREST <- "1.8"

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
# 1.10 Arbeitsumgebung - Histogramm ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "1_10"
LABEL_FRAGE <- "arbeitsumfeld"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "In welchem Arbeitsumfeld sind die \n%s tätig?", NAME_KOLLEKTIV
)

## Welche Column?
COLUMN_OF_INTEREST <- "1.10"

## Benennung der Antwortoptionen (streng nach Reihenfolge!)
VALUE_MAPPING <- c(
  "<200" = "Kleines \nKrankenhaus \n(<200 Betten)",
  "200-500" = "Mittelgroßes \nKrankenhaus \n(200-500 Betten)",
  ">500" = "Schwerpunkt- / \nMaximalversorger \n(>500 Betten)",
  "ambulant" = "Ambulant",
  "präklinisch" = "Ausschließlich \nPräklinisch",
  "sonstiges" = "Sonstiges"
)

## Nochmalige Benennung der Antwortoptionen zur Sortierung (wichtig)
ORDERED_LEVELS <- c(
  "Kleines \nKrankenhaus \n(<200 Betten)",
  "Mittelgroßes \nKrankenhaus \n(200-500 Betten)",
  "Schwerpunkt- / \nMaximalversorger \n(>500 Betten)",
  "Ambulant",
  "Ausschließlich \nPräklinisch",
  "Sonstiges"
)

## Brewer Palette für Farbgebung
BREWER_PALETTE <- "Set2"

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Generate Outputs
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

create_work_environment_distribution_plot(
  filtered_data = filtered_data,
  column_of_interest = COLUMN_OF_INTEREST,
  value_mapping = VALUE_MAPPING,
  ordered_levels = ORDERED_LEVELS,
  NAME_FRAGE = NAME_FRAGE,
  PLOT_TITLE = PLOT_TITLE,
  BREWER_PALETTE = BREWER_PALETTE
)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# 1.11 Hauptsächlich Notaufnahme - Pie-Chart ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "1_11"
LABEL_FRAGE <- "hauptsaechlich_notaufnahme"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Anteil der hauptsächlich in der Notaufnahme tätigen \n%s", NAME_KOLLEKTIV
)

## Titel der angezeigten Labels (kurz, knackig)
LABEL_TITLE <- "Hauptsächlich \nNotaufnahme"

## Welche Column?
COLUMN_OF_INTEREST <- "1.11"

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
# 1.12 Muttersprache - Pie-Chart ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "1_12"
LABEL_FRAGE <- "muttersprache"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Muttersprache der %s", NAME_KOLLEKTIV
)

## Titel der angezeigten Labels (kurz, knackig)
LABEL_TITLE <- "Muttersprache"

## Welche Column?
COLUMN_OF_INTEREST <- "1.12"

# Define mapping for values in dataset
VALUE_MAPPING <- c(
  "TRUE" = "Deutsch",
  "FALSE" = "Andere"
)
## Brewer Palette für Farbgebung
BREWER_PALETTE <- "Pastel1"


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
# PRINT'em ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (PRINT_PLOTS) {
  print(get(paste0("plot_1_01_", LABEL_KOLLEKTIV, "_alter")))
  print(get(paste0("plot_1_05_", LABEL_KOLLEKTIV, "_weiterbildungsjahr")))
  print(get(paste0("plot_1_06_", LABEL_KOLLEKTIV, "_fachrichtung")))
  print(get(paste0("plot_1_08_", LABEL_KOLLEKTIV, "_zusatzbezeichnung")))
  print(get(paste0("plot_1_10_", LABEL_KOLLEKTIV, "_arbeitsumfeld")))
  print(get(paste0("plot_1_11_", LABEL_KOLLEKTIV, "_hauptsaechlich_notaufnahme")))
  print(get(paste0("plot_1_12_", LABEL_KOLLEKTIV, "_muttersprache")))
}


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# Clean up ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#cleanup_workspace()