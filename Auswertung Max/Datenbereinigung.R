source("globals.R")
#Rohdaten in den DataFrame Ergebnisse laden (ansonsten verwende: import Dataset)
Ergebnisse <- read_excel("Rohdaten/30.11.24 Beam-Survey Ergebnisse.xlsx", 
                         col_types = c("text", "text", "skip", 
                                       "skip", "skip", "skip", "skip", "skip", 
                                       "skip", "skip", "text", "text", "text", 
                                       "text", "text", "text", "text", "text", 
                                       "text", "text", "text", "text", "text", 
                                       "text", "text", "text", "text", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "text", "text", "text", "text", "text", 
                                       "text", "text", "text", "text", "text", 
                                       "text", "text", "text", "text", "text", 
                                       "text", "text", "text", "text", "text", 
                                       "numeric", "text", "text", "text", 
                                       "text", "text", "text", "text", "text", 
                                       "text", "text", "text", "text", "text", 
                                       "text", "text", "text", "text", "text", 
                                       "text", "text", "text", "text", "text", 
                                       "text", "text", "text", "text", "text", 
                                       "text", "text", "text", "text", "text", 
                                       "text", "text", "text", "text", "text", 
                                       "text", "text", "text", "text", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "text", "text", 
                                       "text", "text", "text", "text", "text", 
                                       "text", "text", "text", "text", "text", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "text", "text", 
                                       "text", "text", "text", "text", "text", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "text", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "text", "text", "text", "text", "text", 
                                       "text", "text", "text", "text", "text", 
                                       "text", "text", "text"))

# Datenbereinigung | Die Spaltennamen sind in einem seperaten File extrahiert



Spaltennamen <- readLines("Spaltennamen_abbr2.txt")
  colnames(Ergebnisse) <- Spaltennamen

Ergebnisse$Teilnehmer <- seq_len(nrow(Ergebnisse)) 
#Mich nervt die unique ID ; ersetzt durch aufsteigende Zahlen


# Nun erstellen wir einen Haufen Vektoren die wir für später brauchen (für die loops)

# Funktion zum Extrahieren des Präfixes
extract_prefix <- function(name) {
  sub("^(Q[0-9]+).*", "\\1", name)
}

# Präfixe filtern (nur gültige Q-Labels behalten)
valid_names <- grep("^Q[0-9]+", Spaltennamen, value = TRUE)
prefixes <- unique(sapply(valid_names, extract_prefix))

# Vektoren dynamisch erstellen und speichern
for (prefix in prefixes) {
  assign(
    paste0("coln", prefix),
    valid_names[startsWith(valid_names, prefix)]
  )
}

# Optional: überprüfen, ob die Vektoren erstellt wurden
ls(pattern = "^colnQ[0-9]+")


#Bearbeitung der Einzelnen Spalten um sie bearbeitbar zu machen
Ergebnisse_roh <-Ergebnisse
Ergebnisse$Q1 <- as.factor(Ergebnisse$Q1)
Ergebnisse$Q2 <- as.factor(Ergebnisse$Q2)
Ergebnisse$Q3 <- as.factor(Ergebnisse$Q3)

# Um die "true" und "NA" werte zu bearbeiten brauchen wir Zuordnungen, diese werden erweitert.

zuordnungen <- c(

  "Q4Innere" = "Innere Medizin",
  "Q4Allgemeinmedizin" = "Allgemeinmedizin",
  "Q4Anästhesie" = "Anästhesie",
  "Q4Unfallchirurgie" = "Unfallchirurgie",
  "Q4Viszeralchirurgie" = "Viszeralchirurgie",
  "Q4AndereChirurgie" = "Anderes chirurgisches Fachgebiet",
  "Q4Neurologie" = "Neurologie",
  "Q4Urologie" = "Urologie",
  "Q4Sonstiges" = "Sonstiges Fach",
  
  "Q6Innere" = "Innere Medizin",
  "Q6Allgemeinmedizin" = "Allgemeinmedizin",
  "Q6Anästhesie" = "Anästhesie",
  "Q6Unfallchirurgie" = "Unfallchirurgie",
  "Q6Viszeralchirurgie" = "Viszeralchirurgie",
  "Q6AndereChirurgie" = "Anderes chirurgisches Fachgebiet",
  "Q6Neurologie" = "Neurologie",
  "Q6Urologie" = "Urologie",
  "Q6Sonstiges" = "Sonstiges Fach",
  
  "Q7Innere" = "Innere Medizin",
  "Q7Allgemeinmedizin" = "Allgemeinmedizin",
  "Q7Anästhesie" = "Anästhesie",
  "Q7Unfallchirurgie" = "Unfallchirurgie",
  "Q7Viszeralchirurgie" = "Viszeralchirurgie",
  "Q7AndereChirurgie" = "Anderes chirurgisches Fachgebiet",
  "Q7Neurologie" = "Neurologie",
  "Q7Urologie" = "Urologie",
  "Q7Sonstiges" = "Sonstiges Fach",
  
  "Q15AktuellerStand" = "Aktuell bleiben",
  "Q15Interesse" = "Interesse",
  "Q15Angst" = "Angst",
  "Q15CME" = "CME Punkte",
  "Q15Arbeitgeber" = "Arbeitgeber verlangt es",
  "Q15ShowZertifikat" = "Zertifikate zum Ausstellen",
  "Q15Umfeld" = "Umfeld bildet sich fort",
  "Q15FobiAbrechnung" = "Aus Abrechnungsgründen",
  "Q15FobiZertifierung" = "Aus Abrechnungsgründen",
  "Q15QualitaetPat" = "Patientenversorgung verbessern",
  "Q15Qualitaetselbst" = "Qualität meiner Arbeit verbessern",
  
  "Q17OnlineNachricht" = "Online Nachrichtenplattformen",
  "Q17Fachzeitschriftonline" = "Fachzeitschrift (online)",
  "Q17Nachschlagen" = "Nachschlagewerke",
  "Q17Youtube" = "YouTube",
  "Q17Blogs" = "Blogs",
  "Q17socialmedia" = "Social Media",
  "Q17Streamingkolngress" = "Streaming Kongresse",
  "Q17Webinar" = "Webinar",
  "Q17ODEinzel" = "On Demand Videos",
  "Q17ODKurs" = "Online Kurs",
  "Q17Sonstige" = "Sonstige",
  
  "Q18Smartphone" = "Smartphone",
  "Q18Tablet" = "Tablet",
  "Q18PC" = "PC",
  
  "Q20Nachschlagen" = "Nachschlagewerke",
  "Q20Streamingkongress" = "Streaming Kongress",
  "Q20ODEinzel" = "Online Einzelkurs",
  "Q20Podcast" = "Podcast",
  "Q20ODKurs" = "Online Kurs",
  "Q20Sonstige" = "Sonstige",
  
  "Q21VollAG" = "Vollständig vom Arbeitgeber finanziert",
  "Q21VollSelbst" = "Vollständig selbst finanziert",
  "Q21Teilsteils" = "Teilweise Arbeitgeber, teilweise selbst finanziert",
  "Q21Externe" = "Externe Finanzierung",
  "Q21Sonstige" = "Sonstige",
  
  "Q23Grundlagen" = "Grundlagenwissen",
  "Q23AlternativePraesenz" = "Alternative zur Präsenzveranstaltung",
  "Q23FobiSpez" = "Spezialisierte Fortbildung",
  "Q23Aktualitaet" = "Aktualität des Wissens",
  "Q23CME" = "CME-Punkte",
  
  "Q25Textkurz" = "Kurze Texte",
  "Q25TextLang" = "Längere Texte",
  "Q25Audio" = "Audio",
  "Q25Video" = "Video",
  "Q25Livestream" = "Livestream",
  "Q25OnlineSeminarlive" = "Online-Seminar (live)",
  "Q25OnlineVortraglive" = "Online-Vortrag (live)",
  
  "Q26Alltagsrelevanz" = "Alltagsrelevanz",
  "Q26Qualitaetkurs" = "Qualität des Kurses",
  "Q26Bekanntheit" = "Bekanntheit",
  "Q26Fachgesellschaften" = "Empfehlung durch Fachgesellschaften",
  "Q26Zertifikat" = "Zertifikat",
  
  "Q31Suchmaschine" = "Suchmaschine",
  "Q31FobiDB" = "Fortbildungsdatenbank",
  "Q31Anzeigeprint" = "Printanzeige",
  "Q31Email" = "E-Mail",
  "Q31Empfehlung" = "Empfehlung",
  "Q31Fachgesellschaft" = "Fachgesellschaft"
  
  
)

# Iteriere durch die Zuordnungen und ersetze "true" durch die entsprechenden Werte
for (spalte in names(zuordnungen)) {
  if (spalte %in% names(Ergebnisse)) {
    Ergebnisse[[spalte]][Ergebnisse[[spalte]] == "true"] <- zuordnungen[spalte]
  }
}

#Jetzt steht in jeder Spalte mit den og fragen statt "true" die bezeichnung
#Ist einfacher zum auswerten denke ich

Ergebnisse <- Ergebnisse %>%
  unite(Q4, Q4Innere, Q4Allgemeinmedizin, Q4Anästhesie, Q4Unfallchirurgie, Q4Viszeralchirurgie, Q4AndereChirurgie, Q4Neurologie, Q4Urologie, Q4Sonstiges, sep = ", ", na.rm = TRUE, remove = FALSE)
print(df)

Ergebnisse$Q4.2 <- NA
# Alles nach dem ersten ", " in die neue Spalte übertragen
Ergebnisse$Q4.2 <- ifelse(grepl(", ", Ergebnisse$Q4), 
                          sub(".*?, ", "", Ergebnisse$Q4),  # Alles nach dem ersten ", "
                          NA)

# Alles vor dem ersten ", " in der ursprünglichen Spalte lassen
Ergebnisse$Q4 <- ifelse(grepl(", ", Ergebnisse$Q4), 
                        sub(",.*", "", Ergebnisse$Q4),  # Alles vor dem ersten ", "
                        Ergebnisse$Q4)


#Q6 - Approbierte Ärzte, Facharztwunsch

Ergebnisse <- Ergebnisse %>%
  unite(Q6, Q6Innere, Q6Allgemeinmedizin, Q6Anästhesie, Q6Unfallchirurgie, Q6Viszeralchirurgie, Q6AndereChirurgie, Q6Neurologie, Q6Urologie, Q6Sonstiges, sep = ", ", na.rm = TRUE, remove = FALSE)
print(df)

Ergebnisse$Q6.2 <- NA
# Alles nach dem ersten ", " in die neue Spalte übertragen
Ergebnisse$Q6.2 <- ifelse(grepl(", ", Ergebnisse$Q6), 
                          sub(".*?, ", "", Ergebnisse$Q6),  # Alles nach dem ersten ", "
                          NA)

# Alles vor dem ersten ", " in der ursprünglichen Spalte lassen
Ergebnisse$Q6 <- ifelse(grepl(", ", Ergebnisse$Q6), 
                        sub(",.*", "", Ergebnisse$Q6),  # Alles vor dem ersten ", "
                        Ergebnisse$Q6)



#Q7 - FA+, wo FA?

#Arbeit an den blöd extrahierten Spalten

Ergebnisse <- Ergebnisse %>%
  unite(Q7, Q7Innere, Q7Allgemeinmedizin, Q7Anästhesie, Q7Unfallchirurgie, Q7Viszeralchirurgie, Q7AndereChirurgie, Q7Neurologie, Q7Urologie, Q7Sonstiges, sep = ", ", na.rm = TRUE, remove = FALSE)

Ergebnisse$Q7.2 <- NA
# Alles nach dem ersten ", " in die neue Spalte übertragen
Ergebnisse$Q7.2 <- ifelse(grepl(", ", Ergebnisse$Q7), 
                          sub(".*?, ", "", Ergebnisse$Q7),  # Alles nach dem ersten ", "
                          NA)

# Alles vor dem ersten ", " in der ursprünglichen Spalte lassen
Ergebnisse$Q7 <- ifelse(grepl(", ", Ergebnisse$Q7), 
                        sub(",.*", "", Ergebnisse$Q7),  # Alles vor dem ersten ", "
                        Ergebnisse$Q7)

#Q10 - Wo arbeiten Sie?
Ergebnisse$Q10 <- as.factor(Ergebnisse$Q10)

# Der folgende For Loop kombiniert alle Spalten die aus mehreren Spalten bestehen ineinander
#sie werden unter einer neuen Spalte "combined_QX" abgespeichert.
# dies passiert nur für die Spalten mit numerischem Inhalt (um die Likert Skalen in einer Spalte zu haben)

vektor_names <- ls(pattern = "^colnQ[0-9]+")

for (vektor_name in vektor_names) {
  spalten <- get(vektor_name)  # Holt die Spaltennamen aus dem entsprechenden Objekt
  prefix <- sub("coln", "", vektor_name)  # Extrahiert den Präfix (z. B. "Q24")
  
  # Prüfen, ob die Spalten im Dataframe existieren
  spalten <- spalten[spalten %in% colnames(Ergebnisse)]
  
  # Nur numerische Spalten auswählen
  numerische_spalten <- spalten[sapply(Ergebnisse[spalten], is.numeric)]
  
  if (length(numerische_spalten) > 0) {
    # Neue Spalte mit `tidyr::unite` erstellen
    Ergebnisse <- Ergebnisse %>%
      unite(
        col = !!paste0("Combined_", prefix), # Dynamisch benannter Spaltenname
        all_of(numerische_spalten),
        sep = "_",
        na.rm = TRUE,
        remove = FALSE
      )
  } else {
    message("Keine passenden numerischen Spalten gefunden für: ", vektor_name)
  }
}

# Die Spalten haben jetzt alle den Typ "Char" - zur Auswertung sollten die likert Skalen in den Typ "num" oder "int" umgewandelt werden

write.xlsx(Ergebnisse, "Ergebnisse.xlsx", overwrite = TRUE)

Ergebnisse_bearb <- read_excel("Rohdaten/Ergebnisse bearb.xlsx", 
                               col_types = c("numeric", "text", "text", 
                                             "text", "text", "numeric", "text", 
                                             "text", "text", "text", "text", "text", 
                                             "text", "text", "text", "text", "text", 
                                             "text", "text", "text", "text", "text", 
                                             "text", "text", "text", "text", "text", 
                                             "text", "text", "text", "text", "text", 
                                             "text", "text", "text", "text", "text", 
                                             "text", "text", "text", "text", "text", 
                                             "text", "text", "text", "text", "text", 
                                             "text", "text", "text", "text", "text", 
                                             "text", "text", "text", "text", "text", 
                                             "text", "text", "text", "text", "text", 
                                             "text", "text", "text", "text", "text", 
                                             "text", "text", "text", "text", "text", 
                                             "numeric", "numeric", "numeric", 
                                             "numeric", "numeric", "text", "text", 
                                             "text", "text", "text", "text", "text", 
                                             "text", "text", "text", "text", "text", 
                                             "text", "text", "text", "text", "text", 
                                             "text", "text", "text", "text", "text", 
                                             "text", "text", "text", "text", "text", 
                                             "text", "text"))

#Zusammenfassen der Levels in Q2 zu unserer Zielgruppe
Ergebnisse_bearb$Q2 <- fct_recode(Ergebnisse_bearb$Q2,
                                  "AiW" = "Approbierte Ärztin / Arzt vor Beginn der Weiterbildung",
                                  "AiW" = "Arzt/Ärztin in Weiterbildung",
                                  "AiW" = "Sonstiges:Approbierter Arzt nach Anerkennung eines ausländischen Abschlusses",
                                  "Fachärztin / Facharzt" = "Sonstiges:FA Anästhesiologie im Ruhestand",
                                  "Fachärztin / Facharzt" = "Sonstiges:Funktionsoberarzt",
                                  "Fachärztin / Facharzt" = "Sonstiges:Fachärztin in ambulanter Anste",
                                  "Fachärztin / Facharzt" = "Sonstiges:Niedergelassener Facharzt",
                                  "Fachärztin / Facharzt" = "Sonstiges:Notarzt FA Chir. auf Honorarbasis",
                                  "Chefärztin / Chefarzt" = "Sonstiges:Ärztliche leitung",
                                  "Chefärztin / Chefarzt" = "Sonstiges:Ärztlicher Leiter Notau",
                                  "Rettungsdienst" = "Sonstiges:Erwachsenenpädagoge/Notfallsanitäter",
                                  "Rettungsdienst" = "Sonstiges:NFS",
                                  "Rettungsdienst" = "Sonstiges:Notfallrettung / NFS",
                                  "Rettungsdienst" = "Sonstiges:Notfallsan",
                                  "Rettungsdienst" = "Sonstiges:Notfallsani",
                                  "Rettungsdienst" = "Sonstiges:Notfallsanitäter",
                                  "Rettungsdienst" = "Sonstiges:Notfallsanitäter / GKP Anästhesie",
                                  "Rettungsdienst" = "Sonstiges:NotfallsanitäterIN",
                                  "Rettungsdienst" = "Sonstiges:Rettungsassistent",
                                  "Rettungsdienst" = "Sonstiges:Volkswagen AG, Prüfgelände Ehra, Werksicherheit, Brandschutz, Rettungsdienst, Leitstelle.",
                                  "Rettungsdienst" = "Sonstiges:Pädagoge Rettungsdienstschule",
                                  "Rettungsdienst" = "Sonstiges:PA Studentin + NotSan",
                                  "Rettungsdienst" = "Rettungdienst",
                                  "Rettungsdienst" = "Sonstiges:Rettungss",
                                  "Sonstiges" = "Sonstiges:Physician Assistant",
                                  "Sonstiges" = "Sonstiges:Rentner",
                                  "Sonstiges" = "Sonstiges:Studentin",
                                  "Sonstiges" = "Sonstiges:Medizinpädagogin",
                                  "Krankenpflege" = "Sonstiges:Fachkrankenpflege",
                                  "Krankenpflege" = "Sonstiges:Krankenschwester" ,
                                  "Krankenpflege" = "Sonstiges:Leitende Fachpflegekraft für Notfallpflege",
                                  "Krankenpflege" = "Sonstiges:Leitung Weiterbildung Notfallpflege",
                                  "Krankenpflege" = "Sonstiges:Notfallpflege"
)

Ergebnisse_bearb$Q8 <- fct_recode(Ergebnisse_bearb$Q8,
                                  "Ja" = "Ja, ich möchte die Zusatzbezeichnung \"Klinische Akut- und Notfallmedizin\" erwerben",
                                  "Nein" = "Nein, ich möchte die Zusatzbezeichnung \"Klinische Akut- und Notfallmedizin\" nicht erwerben"
)

Ergebnisse_bearb$Q9 <- fct_recode(Ergebnisse_bearb$Q9,
                                  "Besitze" = "Ich habe die Zusatzbezeichnung \"Klinische Akut- und Notfallmedizin\"",
                                  "Nein" = "Ich habe die Zusatzbezeichnung \"Klinische Akut- und Notfallmedizin\" nicht und möchte diese auch nicht erwerben",
                                  "Möchte" = "Ich möchte die Zusatzbezeichnung \"Klinische Akut- und Notfallmedizin\" erwerben"
)
