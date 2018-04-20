library("DBI")
library("rJava")
library(RMySQL)
#MYSQL Driver wordt geinitialiseerd

setwd("C:/Users/Illia/Documents/GitHub/GemeenteAmsterdam_BD2/AmsterdamShiny")

#Databse connectie wordt gemaakt en in "con" gezet
con <- dbConnect(RMySQL::MySQL(), 
                 dbname = "zdoornw001",
                 host = "localhost", 
                 user = "root", 
                 password = "P@ssw0rd", 
                 client.flag = CLIENT_MULTI_STATEMENTS)


#Vragen alle data op in de database
StadsdeelMax <- dbGetQuery(con, "select * from amsterdamDB")

#Hier wordt alle data opgevraagd van alleen de Stadsdelen
stadsdelen <- dbGetQuery(con, "select * from amsterdamDB where niveaunaam = 'Stadsdeel'")


#De max waardes voor elke variabel wordt berekend
maxWaardes <- dbGetQuery(con, "select distinct variabelenaam, max(waarde)  
                                from amsterdamDB where niveaunaam = 'stadsdeel' group by variabelenaam;")

#Nieuwe dataframe "StadsdeelMax" wordt aangemaakt en de 2 bovenstaande dataframes worden gemerged
StadsdeelMax <- merge(stadsdelen, maxWaardes, by.x="variabelenaam", by.y = "variabelenaam")

#Nieuw kolom voor de genormaliseerde waardes worden toegevoegd
StadsdeelMax$genormaliseerd <- NA

#For Loop die voor elke variabel de genormaliseerde waarde berekent
for (i in 1:nrow(stadsdelen)){
  StadsdeelMax$genormaliseerd <- StadsdeelMax$waarde / StadsdeelMax$`max(waarde)`
  
}

#Alle variabelen worden opgehaald en in een dataframe gezet
#Er wordt een nieuwe kolom aangemaakt en de variabelen krijgen unieke ID's
variabels <- as.data.frame(unique(StadsdeelMax$variabelenaam))
variabels$variabele_ID <- 1:nrow(variabels) 

#In "StadsdeelMax" wordt een nieuwe kolom aangemaakt voor de variabel ID's
StadsdeelMax$variabele_ID <- NA

#Dataframes met variabel en ID's worden gemerged en in "StadsdeelMax" gezet
StadsdeelMax <- merge(StadsdeelMax, variabels)

#Dataframe wordt naar de Database geschreven
dbWriteTable(con,name="StadsdeelMax", value=StadsdeelMax , append=FALSE, row.names=FALSE, overwrite=FALSE)





