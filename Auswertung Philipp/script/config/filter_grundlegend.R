########################################################################
####### Rohdaten aus Excel-Datei einfügen
########################################################################
## Excel Datei ist manuell bereinigt worden 
## - Nicht-ÄrztInnen entfernt
## - Sonstiges korrigiert / aufgehübscht
## - Likert-Scale Spalten zusammengefasst
## - ja/nein in Boolean TRUE/FALSE überführt
## - Spaltentitel angepasst
## - Antworten fürs Einlesen in R verbessert
########################################################################

rohdaten_quelldatei <- "./rohdaten/beam-ergebnisse_philipp-edit.xlsx"
rohdaten <- read_excel(rohdaten_quelldatei, sheet = 1)

########################################################################
####### Filter nach Gen-EM Kriterien
####### 
####### filtered_student   = Studenten
####### filtered_assistent = Assistenzärzte + vor Beginn Weiterbildung
####### filtered_facharzt  = Fachärzte
####### filtered_oberarzt  = Oberärzte
####### filtered_chefarzt  = Chefärzte
####### 
########################################################################

## StudentInnen
## Var = filtered_student
filtered_student <- rohdaten %>%
  filter(`1.2` %in% c("student"))

## Arzt in Weiterbildung + Approbiert vor Beginn Weiterbildung
## Var = filtered_assistent
filtered_assistent <- rohdaten %>%
  filter(`1.2` %in% c("arzt_weiterbildung", "approbiert_vor_beginn"))

## Facharzt 
## Var = filtered_facharzt
filtered_facharzt <- rohdaten %>%
  filter(`1.2` %in% c("facharzt"))

## Oberarzt
## Var = filtered_oberarzt
filtered_oberarzt <- rohdaten %>%
  filter(`1.2` %in% c("oberarzt"))

## Chefarzt
## Var = filtered_chefarzt
filtered_chefarzt <- rohdaten %>%
  filter(`1.2` %in% c("chefarzt"))