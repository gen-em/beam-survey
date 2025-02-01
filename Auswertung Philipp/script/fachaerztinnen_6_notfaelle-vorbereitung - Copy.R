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

LABEL_KOLLEKTIV <- "fachaerztinnen"
filtered_data <- get(paste0("filtered_", LABEL_KOLLEKTIV))
NAME_KOLLEKTIV <- get(paste0("name_", LABEL_KOLLEKTIV))

## Sollen die Plots geprintet werden? TRUE = ja, FALSE = nein
PRINT_PLOTS = TRUE

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# 6.33 Vorbereitung Notfälle eigenes Fachgebiet - 7-point Likert ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "6_33"
LABEL_FRAGE <- "nofall_vorbereitet_eigenes_fachgebiet_likert"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Wie gut fühlen sich %s auf Notfälle in Ihrem Fachgebiet vorbereitet?", NAME_KOLLEKTIV
)


SELECTED_COLUMNS <- c(
  "6.33"
)
COLUMN_NAMES <- c(
  "Notfallvorbereitung eigenes Fachgebiet"
)
BREWER_PALETTE <- "RdBu"
MINIMUM_LABEL_PERCENTAGE <- 4
SHOW_Y_LABELS <- FALSE  # Y-Achsen Labels anzeigen
LABELS <- c(
  "1" = "Sehr schlecht",
  "2" = "Schlecht",
  "3" = "Eher schlecht",
  "Neutral" = "Neutral",
  "5" = "Eher gut",
  "6" = "Gut",
  "7" = "Sehr gut"
)


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Generate Outputs
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

assign(paste0("table_", NAME_FRAGE), 
       create_likert_7_table(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES, 
         LABELS
       )
)

assign(paste0("plot_", NAME_FRAGE), 
       create_likert_7_plot(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES,
         PLOT_TITLE, 
         BREWER_PALETTE, 
         MINIMUM_LABEL_PERCENTAGE, 
         LABELS, 
         SHOW_Y_LABELS)
)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# 6.35 Vorbereitung Notfälle anderes Fachgebiet - 7-point Likert ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "6_35"
LABEL_FRAGE <- "nofall_vorbereitet_anderes_fachgebiet_likert"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Wie gut fühlen sich %s auf Notfälle außerhalb ihres Fachgebietes vorbereitet?", NAME_KOLLEKTIV
)


SELECTED_COLUMNS <- c(
  "6.35"
)
COLUMN_NAMES <- c(
  "Notfallvorbereitung andere Fachgebiete"
)
BREWER_PALETTE <- "RdBu"
MINIMUM_LABEL_PERCENTAGE <- 4
SHOW_Y_LABELS <- FALSE  # Y-Achsen Labels anzeigen
LABELS <- c(
  "1" = "Sehr schlecht",
  "2" = "Schlecht",
  "3" = "Eher schlecht",
  "Neutral" = "Neutral",
  "5" = "Eher gut",
  "6" = "Gut",
  "7" = "Sehr gut"
)


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Generate Outputs
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

assign(paste0("table_", NAME_FRAGE), 
       create_likert_7_table(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES, 
         LABELS
       )
)

assign(paste0("plot_", NAME_FRAGE), 
       create_likert_7_plot(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES,
         PLOT_TITLE, 
         BREWER_PALETTE, 
         MINIMUM_LABEL_PERCENTAGE, 
         LABELS, 
         SHOW_Y_LABELS)
)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# PRINT'em ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (PRINT_PLOTS) {  # Only execute if PRINT_PLOTS is TRUE
  print(get(paste0("plot_6_33_", LABEL_KOLLEKTIV, "_nofall_vorbereitet_eigenes_fachgebiet_likert")))
  print(get(paste0("plot_6_35_", LABEL_KOLLEKTIV, "_nofall_vorbereitet_anderes_fachgebiet_likert")))
}

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Clean up ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#cleanup_workspace()