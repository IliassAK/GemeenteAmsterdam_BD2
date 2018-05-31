#Render the comparison map
output$mapCorrelations <- renderLeaflet(createLeafletMap())
mapCorrelationsProxy <- leafletProxy("mapCorrelations")
selectedArea <- ""

#output$comparisonMapdataTable <- renderSelectedAreaInfoTable(input$mapCorrelations_geojson_mouseover$properties)

#Observevent Kaart

observeEvent(input$mapCorrelations_geojson_mouseover, {
  output$comparisonMapdataTable <- renderSelectedAreaInfoTable(input$mapCorrelations_geojson_mouseover$properties)
})


# observe event Indicator Lijst
observeEvent(input$correlationLevel, {
  
  clearMap(mapCorrelationsProxy)
  mapCorrelationsProxy %>% clearControls()
  addToMapCorrelations(mapCorrelationsProxy)
  
})

observeEvent(input$CorrelationElem1, {
  
  levelresults <- selecteerIndicatoren(input$CorrelationElem1, input$correlatieGrens, selectedArea, input$filterCorrelation)
  updateSelectInput(session, "CorrelationElem2",
                    choices = c("", sort(levelresults)),
                    selected = NULL) 
  
  updateCorrelationGraph1(selectedArea)
  
  
})

# Observe event Slider

observeEvent(input$correlatieGrens, {
  
  levelresults <- selecteerIndicatoren(input$CorrelationElem1, input$correlatieGrens, selectedArea, input$filterCorrelation)
  updateSelectInput(session, "CorrelationElem2",
                    choices = c(sort(levelresults)),
                    selected = NULL) 
  
  
})

# Observe event Checkbox

observeEvent(input$filterCorrelation, {
  
  levelresults <- selecteerIndicatoren(input$CorrelationElem1, input$correlatieGrens, selectedArea, input$filterCorrelation)
  updateSelectInput(session, "CorrelationElem2",
                    choices = c(sort(levelresults)),
                    selected = NULL) 
  
  
  
  
})

observeEvent(input$mapCorrelations_geojson_mouseover, {
  output$comparisonMapdataTable <- renderSelectedAreaInfoTable(input$mapCorrelations_geojson_mouseover$properties)
})

observeEvent(input$mapCorrelations_geojson_click, {
  
  #selectedArea <- input$mapCorrelations_geojson_click$properties
  code <- input$mapCorrelations_geojson_click$properties$gebiedcode
  selectedCode <<- code
  
  
  
  
  gebiedgekozen<- gebieden[grep(code, gebieden$gebiedcode), ]
  gebiedgekozen<- gebiedgekozen[grep("Stadsdeel", gebiedgekozen$niveaunaam), ]
  
  output$code<-renderUI({
    gebiedgekozen$gebiednaam
    
  })
  
  selectedArea <<- gebiedgekozen$gebiednaam
  
  levelresults <- selecteerIndicatoren(input$CorrelationElem1, input$correlatieGrens, selectedArea, input$filterCorrelation)
  updateSelectInput(session, "CorrelationElem2",
                    choices = c(sort(levelresults)),
                    selected = NULL) 
  
  updateCorrelationGraph1(selectedArea)
  
  
})




# Observe event Graph list

observeEvent(input$CorrelationElem2, {
  
  
  
  updateCorrelationGraph1(selectedArea)
  updateCorrelationGraph2(selectedArea)
  
  
  
  
})