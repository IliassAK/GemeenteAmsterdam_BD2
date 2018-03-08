updateSelectInput(session, "levelLeefbaarheid", choices = c(placeholderInputString, getLevelVector("Leefbaarheid", "LHSCORE")))

#Render the leefbaarheid map
output$leefbaarheidMap <- renderLeaflet({
  createLeafletMap() %>% addLegend("topright", colors = c("#730000", "#E50000", "#E1702E", "#FFFFBE", "#D3FFBE", "#93E667", "#55BE00", "#267300","#263D00"), 
              labels = c("Zeer onvoldoende", "Ruim onvoldoende", "Onvoldoende", "Zwak", "Voldoene", "Ruim voldoende", 
                         "Goed", "Zeer goed", "Uitstekend"), title = "Leefbaarheid")
})
leefbaarheidProxy <- leafletProxy("leefbaarheidMap")

# Filter leefbaarheid level
observeEvent(input$levelLeefbaarheid,{
  print("Leefbaarheid observe called")
  if(input$levelLeefbaarheid == emptyInputString || input$levelLeefbaarheid == placeholderInputString)
    return()
  
  clearMap(leefbaarheidProxy)
  lhScores <- getDataDF("Leefbaarheid", "LHSCORE", input$levelLeefbaarheid)
  latestYear <- lhScores[nrow(lhScores),c("jaar")]
  lhScores <- lhScores %>% filter(jaar == latestYear)
  
  output$chartVergelijkingLeefbaarheid <- leefbaarheidVergelijkingGebiedenPlot(lhScores, NA)
  addToMapLeefbaarheid(leefbaarheidProxy, input$levelLeefbaarheid)
  
})

# Set the datable in the right column to the mouseover area on the map
observeEvent(input$leefbaarheidMap_geojson_mouseover, {
  output$leefbaarheidMapdataTable <- renderSelectedAreaInfoTable(input$leefbaarheidMap_geojson_mouseover$properties)
})


observeEvent(input$leefbaarheidMap_geojson_click, {
  clickedItemGebiedCode <- input$leefbaarheidMap_geojson_click$properties$gebiedcode
  
  
  lhScores <- getDataDF("Leefbaarheid", "LHSCORE", input$levelLeefbaarheid)
  latestYear <- lhScores[nrow(lhScores),c("jaar")]
  lhScores <- lhScores %>% filter(jaar == latestYear)
  
  currentGebied <- lhScores %>% filter(gebiedcode == clickedItemGebiedCode)
  if(nrow(currentGebied) == 0) {
    return()
  }
  
  lhScores2 <- getDataDF("Leefbaarheid", "LHSCORE", input$levelLeefbaarheid)
  latestYear <- lhScores2[nrow(lhScores2),c("jaar")]
  lhScores2 <- lhScores2 %>% filter(jaar == latestYear)
  
  output$chartVergelijkingLeefbaarheid <- leefbaarheidVergelijkingGebiedenPlot(lhScores, clickedItemGebiedCode)
  output$chartLeefbaarheid <- leefbaarheidDimensiePlot(clickedItemGebiedCode, input$levelLeefbaarheid)
  output$leefbaarheidText <- renderText(HTML(paste('<div class="scoreInfo">', leefbaarheidWaardeText[currentGebied$waarde], '<div>')))
  output$leefbaarheidTable <- leefbaarheidScoreDataTable(clickedItemGebiedCode, input$levelLeefbaarheid)
  })