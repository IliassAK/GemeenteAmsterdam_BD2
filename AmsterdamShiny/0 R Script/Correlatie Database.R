library("DBI")
library("rJava")
library(RMySQL)

con <- dbConnect(RMySQL::MySQL(), 
                 dbname = "zdoornw001",
                 host = "localhost", 
                 user = "root", 
                 password = "P@ssw0rd", 
                 client.flag = CLIENT_MULTI_STATEMENTS)



SDNieuw_west_Correlaties <- dbGetQuery(con, "select * from SDNieuw_west_correlaties ")
SDNoord_Correlaties <- dbGetQuery(con, "select * from SDNoord_correlaties ")
SDCentrum_Correlaties <- dbGetQuery(con, "select * from SDcentrum_correlaties ")
SDOost_Correlaties <- dbGetQuery(con, "select * from SDoost_correlaties ")
SDWest_Correlaties <- dbGetQuery(con, "select * from SDwest_correlaties ")
SDWestpoort_Correlaties <- dbGetQuery(con, "select * from SDwestpoort_correlaties ")
SDZuid_Correlaties <- dbGetQuery(con, "select * from SDzuid_correlaties ")
SDZuidoost_Correlaties <- dbGetQuery(con, "select * from SDzuidoost_correlaties ")

SDNieuw_west_Correlaties$correlations_id <- "Nieuw-West"

SDNoord_Correlaties$correlations_id <- "Noord"

SDCentrum_Correlaties$correlations_id<- "Centrum"

SDOost_Correlaties$correlations_id <- "Oost"

SDWest_Correlaties$correlations_id <- "West"

SDWestpoort_Correlaties$correlations_id <- "Westpoort"


SDZuid_Correlaties$correlations_id <- "Zuid"


SDZuidoost_Correlaties$correlations_id <- "Zuidoost"

SDTotaal <- as.data.frame(rbind(SDNieuw_west_Correlaties,SDNoord_Correlaties,SDCentrum_Correlaties, SDWest_Correlaties,SDWestpoort_Correlaties,SDZuid_Correlaties,SDZuidoost_Correlaties))


stadsdeelmax <- dbGetQuery(con, "select distinct(variabele_ID),  variabelenaam, thema,label from stadsdeelmax ")


StadsdeelTotaal <- merge(SDTotaal, stadsdeelmax, by.x = "statistics_1_id", by.y = "variabele_ID")

colnames(StadsdeelTotaal)[5]<- "variabelenaam_1"  
colnames(StadsdeelTotaal)[6]<- "thema_1"

colnames(StadsdeelTotaal)[7]<- "label_1" 

SDTotaal <- rbind(SDTotaal, SDOost_Correlaties)

StadsdeelTotaal <- merge(StadsdeelTotaal, stadsdeelmax, by.x = "statistics_2_id", by.y = "variabele_ID")

colnames(SDTotaal)[1] <- "Stadsdeel" 


colnames(StadsdeelTotaal)[8]<- "variabelenaam_2"  
colnames(StadsdeelTotaal)[9]<- "thema_2"

colnames(StadsdeelTotaal)[10]<- "label_2" 

StadsdeelTotaal<- StadsdeelTotaal[,c(3,2,5,6,7,1,8,9,10,4)]



dbWriteTable(con, "CorrelatieTotaal", StadsdeelTotaal, append=FALSE, row.names=FALSE, overwrite=FALSE)

