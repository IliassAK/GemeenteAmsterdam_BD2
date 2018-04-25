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


#Alle beschikbare tabellen worden weergegeven
dbListTables(con)

#Gegevens worden uit de database opgehaald
kernCijfer <- dbGetQuery(con, "select * from kerncijfer")
metaData <- dbGetQuery(con, "select * from metadata")
gebieden <- dbGetQuery(con, "select * from gebieden")
gebiedenJson <- dbGetQuery(con, "select * from gebiedenjson")

#Onnodige kolommen worden weg gegooid
gebieden[,c(6,8,9,10,11,2)] <- NULL
metaData[,c(1,6,7,8,11,12,13,14,15,16,17,18,19)] <- NULL

#Kolommen worden hier gemerged en in een nieuwe dataframe gezet "gebiedenCijfer"
gebiedenCijfer <- merge(kernCijfer, gebieden)
gebiedenCijfer <- merge(gebiedenCijfer, metaData)

#De kolommen worden op opnieuw georderd
gebiedenCijfer <- gebiedenCijfer[,c(9,10,5,7,8,3,11,1,4,12,13,2,6)]

#Data wordt naar een CSV en de database geschreven
write.csv(gebiedenCijfer, "gebiedenCijfer.csv")
dbWriteTable(con, "amsterdamDB", gebiedenCijfer, overwrite = TRUE)
