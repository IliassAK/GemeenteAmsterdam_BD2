library("data.table")

Correlaties <- dbGetQuery(connectDb(), "Select * from correlaties")

# getThemeLabeledIndicatorList()
observe({
  

  varCorr<- input$corr
  
  varElemen1 <- input$CorrelationElem1
  
  leegCorr <-c()
  
  Correlaties<- as.data.table(Correlaties)
  
  dfuiCorrelatie<- setkey(Correlaties,indicator1, correlatie)
  
  dfuiCorrelatieUpdate<- unique(dfuiCorrelatie) %>% subset(indicator1 == varElemen1) %>% subset(correlatie >= varCorr)
  
  

  
  leegCorr<- c(dfuiCorrelatieUpdate$indicator2)
  
  
  
  updateSelectInput(session,
                       
                       inputId =  "Corr2",
                       
                       choices = leegCorr,
                      label = "Indicator 2",
                       
                       selected= NULL)
  
})




















# CorrFunc <- function(x,y){
#   
# 
#   
#   sqll <- paste("SELECT indicator2 from correlaties WHERE correlatie >= ", x," AND indicator1 like '", y,"'", sep = "")
#   
#   CorrMatrix <- dbGetQuery(connectDb(), sqll)
#   
#   as.data.frame(CorrMatrix)
# }


output$secondSelection <- renderUI({
  
  observe({
    updateSelectInput(session, "secondSelection",
                      choices = CorrFunc(input$corr, input$CorrelationElem1)
    )})
})





