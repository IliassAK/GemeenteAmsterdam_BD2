library(shiny)

function(input, output, session) {
  print("Server started")
  

  # Common functions -------------
  source("common//mapFunctions.R", local=TRUE)

  # Tiles tab -----------------
  source("tabTiles//tileFunctions.R", local=TRUE)
  source("tabTiles//serverTiles.R", local=TRUE)

  # Per gebied --------------
  source("tabPerGebied//gebiedFunctions.R",local=TRUE)
  source("tabPerGebied//gebiedHistogram.R",local=TRUE)
  source("tabPerGebied//pergebied.R",local=TRUE)
  
  #per indicator tab --------
  source("tabPerIndicator//indicatorFunctions.R",local=TRUE)
  source("tabPerIndicator//perindicator.R",local=TRUE)
  
  #data viewer tab ------------
  source("tabDataviewer//dataviewer.R",local=TRUE)
  
  #leefbaarheid tab -------------
  source("tabLeefbaarheid//leefbaarheidFunctions.R", local=TRUE)
  source("tabLeefbaarheid//leefbaarheid.R", local=TRUE)
  
  source("tabTest//test.R", local=TRUE)
  source("tabTest//testFunctions.R", local=TRUE)
  
  #Disclaimer --------------
  
  output$disclaimer <- renderText(
    HTML(
      "<div style=\"position: static; margin-top:10px;\">",
      "Disclaimer: alle gegevens in deze applicatie zijn onder voorbehoud en er kunnen geen rechten aan worden ontleend.",
      "</div>"
    )
  )
  
}