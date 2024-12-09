source("globals.R")

#Nachdem die Daten nun etwas aufgehübscht und bereinigt wurden, wird hier weiter gearbeitet.

library(readxl)
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


 # Zuerst werden alle "Zahlen" vom Typ Char in num umgewandelt. Das braucht man später für die Rechnerei
 
 for (spalte in colnames(Ergebnisse_bearb)) {
   # Überprüfen, ob in der Spalte nur eine Zahl steht
   if (length(unique(Ergebnisse_bearb[[spalte]])) == 1 && is.character(Ergebnisse_bearb[[spalte]])) {
     # Falls die Spalte nur eine Zahl enthält, als numeric umwandeln
     Ergebnisse_bearb[[spalte]] <- as.numeric(Ergebnisse_bearb[[spalte]])
   }
 }

 
 # Nun werden die entsprechenden Dinge faktorisiert, die Faktoren sind (wichtig für die Auswertung)
 
 Ergebnisse_bearb$Q1 <- as.factor(Ergebnisse_bearb$Q1)
 Ergebnisse_bearb$Q2 <- as.factor(Ergebnisse_bearb$Q2)
 Ergebnisse_bearb$Q3 <- as.factor(Ergebnisse_bearb$Q3)
 Ergebnisse_bearb$Q8 <- as.factor(Ergebnisse_bearb$Q8)
 Ergebnisse_bearb$Q9 <- as.factor(Ergebnisse_bearb$Q9)
 Ergebnisse_bearb$Q10 <- as.factor(Ergebnisse_bearb$Q10)
 Ergebnisse_bearb$Q11 <- as.factor(Ergebnisse_bearb$Q11)
 Ergebnisse_bearb$Q12 <- as.factor(Ergebnisse_bearb$Q12)
 Ergebnisse_bearb$Q19 <- as.factor(Ergebnisse_bearb$Q19)
 Ergebnisse_bearb$Q43 <- as.factor(Ergebnisse_bearb$Q43)
 Ergebnisse_bearb$Q44 <- as.factor(Ergebnisse_bearb$Q44)
 Ergebnisse_bearb$Q45 <- as.factor(Ergebnisse_bearb$Q45)
 Ergebnisse_bearb$Q46 <- as.factor(Ergebnisse_bearb$Q46)
 Ergebnisse_bearb$Q47 <- as.factor(Ergebnisse_bearb$Q47)
 Ergebnisse_bearb$Q48 <- as.factor(Ergebnisse_bearb$Q48)
 Ergebnisse_bearb$Q49 <- as.factor(Ergebnisse_bearb$Q49)
 Ergebnisse_bearb$Q50 <- as.factor(Ergebnisse_bearb$Q50)
 
 Ergebnisse_rescue <- Ergebnisse_bearb

#Erstellen einer Liste mit Leuten, die AiW sind und kontaktiert werden möchten.
 
Ergebnisse_bearb$Q51InfoFortbildung <- as.logical(Ergebnisse_bearb$Q51InfoFortbildung) 
 
kontaktaiw <- Ergebnisse_bearb %>%
  filter(Q51InfoFortbildung == TRUE & !is.na(Email) & Email != "" &Q2 =="AiW")

write.xlsx(kontaktaiw, "Kontakt-AiW.xlsx", overwrite = TRUE)

# Altersverteilung: Daten vorbereiten | Start ggplot 2 mit Daten und so
alter <- kontaktaiw %>%
  count(Q1) %>%
  mutate(percentage = n / sum(n))

# Tortendiagramm erstellen
ggplot(alter, aes(x = "", y = percentage, fill = Q1)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  geom_text(aes(label = scales::percent(percentage)), 
            position = position_stack(vjust = 0.5)) +
  labs(title = "Altersverteilung") +
  theme_void() +
  theme(legend.position = "bottom")

wbjahr <- kontaktaiw %>%  
  count(Q5Weiterbildungsjahr) %>%
  mutate(percentage = n / sum(n))

ggplot(wbjahr, aes(x = "", y = percentage, fill = Q5Weiterbildungsjahr)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  geom_text(aes(label = scales::percent(percentage)), 
            position = position_stack(vjust = 0.5)) +
  labs(title = "Weiterbildungsjahr") +
  theme_void() +
  theme(legend.position = "bottom")


berufsv <- Ergebnisse_bearb %>%
  count(Q2) %>%
  mutate(percentage = n / sum(n))

ggplot(berufsv, aes(x = "", y = percentage, fill = Q2)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  geom_text(aes(label = scales::percent(percentage)), 
            position = position_stack(vjust = 0.5)) +
  labs(title = "Altersverteilung") +
  theme_void() +
  theme(legend.position = "bottom")

Interesse <- kontaktaiw %>%
  count(Q15Interesse) %>%
  mutate(percentage = n / sum(n))

Angst <- kontaktaiw %>%
  count(Q15Angst) %>%
  mutate(percentage = n / sum(n))

Stand <- kontaktaiw %>%
  count(Q15AktuellerStand) %>%
  mutate(percentage = n / sum(n))

QualiS <- kontaktaiw %>%
  count(Q15Qualitaetselbst) %>%
  mutate(percentage = n / sum(n))

QualiP <- kontaktaiw %>%
  count(Q15QualitaetPat) %>%
  mutate(percentage = n / sum(n))

Q15Zusammenfassung <- Interesse %>%
  full_join(Angst, by = "percentage") %>%
  full_join(Stand, by = "percentage") %>%
  full_join(QualiS, by = "percentage") %>%
  full_join(QualiP, by = "percentage")

write.xlsx(Q15Zusammenfassung, "Motivation.xlsx", overwrite = TRUE)

Geld1 <- kontaktaiw %>%
  count(Q49) %>%
  mutate(Anteil = n / sum(n))

Geld2 <- kontaktaiw %>%
  count(Q50) %>%
  mutate(Anteil = n / sum(n))

write.xlsx(Geld1, "Geld1.xlsx", overwirte = TRUE)
write.xlsx(Geld2, "Geld2.xlsx", overwirte = TRUE)
