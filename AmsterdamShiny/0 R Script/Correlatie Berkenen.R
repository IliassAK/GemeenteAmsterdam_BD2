library("DBI")
library("rJava")
#library("RJDBC")
library(RMySQL)

con <- dbConnect(RMySQL::MySQL(), 
                 dbname = "zdoornw001",
                 host = "localhost", 
                 user = "root", 
                 password = "P@ssw0rd", 
                 client.flag = CLIENT_MULTI_STATEMENTS)


#Alle Stadsdelen wordene hier opgehaald en in aparte dataframes gezet
SDNieuw_west <- dbGetQuery(con, "select * 
                                from stadsdeelmax where stadsdeelnaam = 'Nieuw-West'")

SDZuidoost <- dbGetQuery(con, "select * 
                                from stadsdeelmax where stadsdeelnaam = 'Zuidoost'")

SDCentrum <- dbGetQuery(con, "select * 
                                from stadsdeelmax where stadsdeelnaam = 'Centrum'")

SDNoord <- dbGetQuery(con, "select * 
                                from stadsdeelmax where stadsdeelnaam = 'Noord'")

SDWest <- dbGetQuery(con, "select * 
                                from stadsdeelmax where stadsdeelnaam = 'West'")


SDOost <- dbGetQuery(con, "select * 
                                from stadsdeelmax where stadsdeelnaam = 'Oost'")


SDWestpoort <- dbGetQuery(con, "select * 
                                from stadsdeelmax where stadsdeelnaam = 'Westpoort'")



SDZuid <- dbGetQuery(con, "select * 
                                from stadsdeelmax where stadsdeelnaam = 'Zuid'")




#Stadsdelen worden in een list gezet
stadsdeelNamen <- c("SDNieuw_west", "SDZuidoost", "SDCentrum", "SDNoord","SDWest", "SDOost", "SDWestpoort", "SDZuid")
stadsdelenList <- list(SDNieuw_west, SDZuidoost, SDCentrum, SDNoord,SDWest, SDOost, SDWestpoort, SDZuid)
names(stadsdelenList) <- c("SDNieuw_west", "SDZuidoost", "SDCentrum", "SDNoord","SDWest", "SDOost", "SDWestpoort", "SDZuid")
stadsdeelCorrelaties <- c("SDNieuw_west_Correlaties", "SDZuidoost_Correlaties", "SDCentrum_Correlaties", "SDNoord_Correlaties","SDWest_Correlaties", "SDOost_Correlaties", "SDWestpoort_Correlaties", "SDZuid_Correlaties")





x<- 1

for(s in stadsdelenList){
  
  # Een data frame wordt aangemaakt waar de correlaties in gaan komen
  correlations <- data.frame(
    correlations_id = numeric(0),
    statistics_1_id = numeric(0),
    statistics_2_id = numeric(0),
    value = numeric(0))
  
  temp_correlations <- data.frame(
    correlations_id = numeric(0),
    statistics_1_id = numeric(0),
    statistics_2_id = numeric(0),
    value = numeric(0))
  
#Alle Variabel ID's worden opgehaald en in stat_ids gezet.
stat_ids <- unique(s$variabele_ID)

#In dit for loopje worden alle mogelijke combinaties van variabel ID's gezet
#Dit wordt in de dataframe "temp_correlations" gezet
for(i in 1:length(stat_ids)) {
  for(j in i:length(stat_ids)) {
    if(i == j) {next}
    
    row <- data.frame(
      correlations_id = numeric(1),
      statistics_1_id = stat_ids[i],
      statistics_2_id = stat_ids[j],
      value = numeric(1))
    
    temp_correlations <- rbind(temp_correlations, row)
    
  }
 cat('Processing', i, 'of', length(stat_ids), 'in list number:', x , '\n')
}



#Als alle mogelijke combinaties in "temp_correlations" zijn geplaatst, worden deze
#in de dataframe "correlations" gezet.
correlations <- rbind(correlations, temp_correlations)

#Elke mogelijke combinatie krijgt een unieke ID                     
correlations$correlations_id <- 1:nrow(correlations)



#Vanaf hier worden de correlaties per rij berekend

  
for(i in 1:nrow(correlations)) {

  
  #In de onderstaande 2 dataframes worden de combinaties per rij opgehaald. Bijvoorbeeld variabel 1 & variabel 2
  #Deze worden opgehaald uit de dataframe waar variabel_ID gelijk is aan het id wat in "correlations" staat
  cor_1_facts <- s[s$variabele_ID == correlations[i,]$statistics_1_id,]
  cor_2_facts <- s[s$variabele_ID == correlations[i,]$statistics_2_id,]
  
  #Als er geen waardes zijn voor een ID dan wordt de loop gestopt en gaan we verder met de volgende
  if(nrow(cor_1_facts) == 0 | nrow(cor_2_facts) == 0) {next}
  
  
  # Om Correlaties correct te berekenen, worden de jaren opgeslagen in 2 vectors.
  cor_1_years <- unique(cor_1_facts$jaar)
  cor_2_years <- unique(cor_2_facts$jaar)
  
  #Correlaties kunnen alleen berekend worden met overlappende jaren. 
  #Hier worden de jaren die voorkomene in beide vectors in "years" gezet
  years <- Reduce(intersect, list(cor_1_years, cor_2_years))
  
  # Als er geen overlappende jaren zijn wordt de loop gestopt en gaan we verder met de volgende
  if(length(years) == 0) {next}
  
  # Nieuwe dataframe wordt aangemaakt in de overlappende jaren en waardes in op te slaan.
  cor_1_facts_sum <- data.frame(year = numeric(0), value = numeric(0))
  
  #For Loop die voor elk jaar in de vector "years" de genormaliseerde waarde van variabel 1 opvraagt en vervolgens in 
  #de bovengemaakte dataframe plaatst
  for(j in 1:length(years)) {
    year_values <- cor_1_facts[cor_1_facts$jaar == years[j],]$genormaliseerd
    
    cor_1_facts_sum <- rbind(cor_1_facts_sum, data.frame(year = years[j], value = sum(year_values)))
  }
  
  # Nieuwe dataframe wordt aangemaakt in de overlappende jaren en waardes in op te slaan.
  cor_2_facts_sum <- data.frame(year = numeric(0), value = numeric(0))
  
  #For Loop die voor elk jaar in de vector "years" de genormaliseerde waarde van variabel 2 opvraagt en vervolgens in 
  #de bovengemaakte dataframe plaatst
  for(j in 1:length(years)) {
    year_values <- cor_2_facts[cor_2_facts$jaar == years[j],]$genormaliseerd
    
    cor_2_facts_sum <- rbind(cor_2_facts_sum, data.frame(year = years[j], value = sum(year_values)))
  }

  # De dataframes worden gesorteerd op jaar
  cor_1_facts_sum <- cor_1_facts_sum[order(cor_1_facts_sum$year),]
  cor_2_facts_sum <- cor_2_facts_sum[order(cor_2_facts_sum$year),]
  
  # Hier worden de correlaties berekend en geplaatst in de dataframe
  correlations[i,]$value <- cor(x = cor_1_facts_sum$value, y = cor_2_facts_sum$value)
  
  
  
}


#Omdat sommige variabelen geen correlaties hebben, worden de ze weg gegooid. 
correlations <- correlations[!is.na(correlations$value),]

  assign(stadsdeelCorrelaties[x],correlations)
  
  x<- x +1
  

}

#Alle correlaties van de stadsdelen worden in een list gezet en correct genoemd
correlatieList <- list(SDNieuw_west_Correlaties, SDZuidoost_Correlaties, SDNoord_Correlaties,
                       SDWestpoort_Correlaties,SDWest_Correlaties, SDZuid_Correlaties, SDCentrum_Correlaties, SDOost_Correlaties)

names(correlatieList) <- c("SDNieuw_west", "SDZuidoost", "SDNoord", "SDWestpoort","SDWest", "SDZuid", "SDCentrum", "SDOost")



#FOR loop die alle 0.0 values weg gooid
for (c in correlatieList) {
  
  
  c <- c[-which(c$value == 0.0000000), ]
  
}



 


# Alles wordt naar de Database geschreven
# dbWriteTable(con, "SDNieuw_West_Correlaties", SDNieuw_west_Correlaties, overwrite = TRUE)
# dbWriteTable(con, "SDZuidoost_Correlaties", SDZuidoost_Correlaties, overwrite = TRUE)
# dbWriteTable(con, "SDNoord_Correlaties", SDNoord_Correlaties, overwrite = TRUE)
# dbWriteTable(con, "SDWestpoort_Correlaties", SDWestpoort_Correlaties, overwrite = TRUE)
# dbWriteTable(con, "SDWest_Correlaties", SDWest_Correlaties, overwrite = TRUE)
# dbWriteTable(con, "SDZuid_Correlaties", SDZuid_Correlaties, overwrite = TRUE)
# dbWriteTable(con, "SDCentrum_Correlaties", SDCentrum_Correlaties, overwrite = TRUE)
# dbWriteTable(con, "SDOost_Correlaties", SDOost_Correlaties, overwrite = TRUE)
