library("DBI")
library("rJava")
#library("RJDBC")
library(RMySQL)
#MYSQL Driver wordt geinitialiseerd
#drv <- JDBC("com.mysql.jdbc.Driver", "C:/Users/Illia/Desktop/School/SNE Jaar 2/Big Data/Drivers/mysql-connector-java-5.1.45-bin.jar")
setwd("C:/Users/Illia/Documents/GitHub/GemeenteAmsterdam_BD2/AmsterdamShiny")
con <- dbConnect(RMySQL::MySQL(), 
                 dbname = "zdoornw001",
                 host = "localhost", 
                 user = "root", 
                 password = "P@ssw0rd", 
                 client.flag = CLIENT_MULTI_STATEMENTS)


#Vragen alle data op in de database
allData <- dbGetQuery(con, "select * from amsterdamDB")

#Hier wordt alle data opgevraagd van alleen de Stadsdelen en wordt een lege colom toegevoegd
stadsdelen <- dbGetQuery(con, "select * from amsterdamDB where niveaunaam = 'Stadsdeel'")


#De max waardes voor elke variabel wordt berekend
maxWaardes <- dbGetQuery(con, "select distinct variabelenaam, max(waarde)  
                                from amsterdamDB where niveaunaam = 'stadsdeel' group by variabelenaam;")

StadsdeelMax <- merge(stadsdelen, maxWaardes, by.x="variabelenaam", by.y = "variabelenaam")
StadsdeelMax$genormaliseerd <- NA

for (i in 1:nrow(stadsdelen)){
  StadsdeelMax$genormaliseerd <- StadsdeelMax$waarde / StadsdeelMax$`max(waarde)`
  
}


