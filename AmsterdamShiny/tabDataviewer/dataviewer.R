#render lege data viewer met juiste column names
output$tabledata <- DT::renderDataTable({
  DT::datatable(getLeafStructureDf()[,c("jaar","waarde","variabelenaam","label","gebiedcode","gebiednaam")], #mooie volgorde
                options = list(
                  orderClasses = TRUE
                ))
})

#geeft selectie weer in data viewer
observeEvent(input$dataViewerSubmitButton, {
  # Create the datatable for the viewer
  output$tabledata <- DT::renderDataTable({                    
    DT::datatable(getDataDFForFullIndicator(input$dataViewerIndicator)[,c("jaar","waarde","variabelenaam","label","gebiedcode","gebiednaam")], #mooie volgorde
                  options = list(
                    orderClasses = TRUE
                  ))
  })
})

#download de selectie uit de data viewer
output$downloadViewerData <- downloadHandler(
  filename = function() {
    paste("Data_export", "csv", sep=".")
  },
  content = function(file) {
    write.csv(getDataDFForFullIndicator(input$dataViewerIndicator), file, row.names = FALSE)
  }
)