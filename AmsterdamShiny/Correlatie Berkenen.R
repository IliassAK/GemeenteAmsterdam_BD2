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

#MYSQL gegevens worden opgeslagen in conn
# conn <- dbConnect(drv, "jdbc:mysql://localhost/zdoornw001", "root", "P@ssw0rd", useSSL=FALSE)

#Alle beschikbare tabellen worden weergegeven
dbListTables(con)

kernCijfer <- dbGetQuery(con, "select * from kerncijfer")
metaData <- dbGetQuery(con, "select * from metadata")
gebieden <- dbGetQuery(con, "select * from gebieden")
gebiedenJson <- dbGetQuery(con, "select * from gebiedenjson")


gebieden[,c(6,8,9,10,11,2)] <- NULL
metaData[,c(1,6,7,8,11,12,13,14,15,16,17,18,19)] <- NULL

gebiedenCijfer <- merge(kernCijfer, gebieden)
gebiedenCijfer <- merge(gebiedenCijfer, metaData)
gebiedenCijfer <- gebiedenCijfer[,c(9,10,5,7,8,3,11,1,4,12,13,2,6)]

write.csv(gebiedenCijfer, "gebiedenCijfer.csv")
dbWriteTable(con, "amsterdamDB", DataFrame, overwrite = TRUE)
