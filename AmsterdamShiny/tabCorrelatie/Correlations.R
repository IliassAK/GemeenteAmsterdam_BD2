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




correlatieList <- list(SDNieuw_west_Correlaties, SDZuidoost_Correlaties, SDNoord_Correlaties,
                       SDWestpoort_Correlaties,SDWest_Correlaties, SDZuid_Correlaties, SDCentrum_Correlaties, SDOost_Correlaties)

names(correlatieList) <- c("Nieuw-west", "Zuidoost", "Noord", "Westpoort","West", "Zuid", "Centrum", "Oost")


label_ids <- unique(dbGetQuery(con, "select variabele_ID, label from stadsdeelMax"))
stadsdeelMax <- dbGetQuery(con, "select * from stadsdeelmax")


observe({
  
  
  
  
  
  
  
  
  
  
  indicator_id <-label_ids$variabele_ID %>% subset(input$corr_id1 == label_ids$label)
  
  
  indicator_id2 <- NULL
  getLabel<- function(x)
  {
    slider <- input$corr_slider
    value <- correlatieList[[x]]$value 
    
    
    indicator_id2 <- correlatieList[[x]]$statistics_2_id %>% subset(indicator_id == correlatieList[[x]]$statistics_1_id) %>% subset(value >= slider)
    
    indicator_label2 <- label_ids[label_ids$variabele_ID%in%indicator_id2,2 ] 
    updateSelectInput(session, 
                      
                      inputId = "corr_id2",
                      choices = c(indicator_label2),
                      label = "Selecteer Indicator 2",
                      selected= NULL)
    
    
    
  }
  
  getLabel(input$stadsdelen)
  
  cat("First Indicators" ,indicator_id ,'\n')
  cat("Second Indicators" ,indicator_id2 ,'\n')
  
  
})