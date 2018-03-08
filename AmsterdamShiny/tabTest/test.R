output$testtekst <- renderText(
  HTML(
    "<div style=\"position: static; margin-top:10px;\">",
    "Dit is een test pagina",
    "</div>"
  
)
)


VeiligheidGevoel <- dataTree[["Veiligheid"]][["VVEILIGVOELEN_P"]][["Wijk"]][["waarde"]]
jaar <- dataTree[["Veiligheid"]][["VVEILIGVOELEN_P"]][["Wijk"]][["jaar"]]

output$testplot <- renderPlot(plot(VeiligheidGevoel,jaar))



#output$distPlot <- renderPlot({
#  x <- dataTree[["Veiligheid"]][["VVEILIGVOELEN_P"]][["Wijk"]][["waarde"]][1:10]
#  bins <- seq(min(x), max(x), length.out = input$bins + 1)
#  
#  hist(x, breaks = bins, col = "#75AADB", border = "white",
#       xlab = "Test",
#       main = "test2")
#  })




#output$hist <- renderPlot(hist(VeiligheidGevoel, Bevolkingdeel))
#hist(VeiligheidGevoel)

#hist(mtcars$wt, main = "Weight", xlab = "Weight in (1000s)")
#hist(mtcars$mpg, main = "MPG" , xlab= "Miles Per Gallon")
#plot(mtcars$wt, mtcars$mpg, main = "Weight vs MPG", xlab="Weight (in 1000s)", ylab="Miles Per Gallon")
#cor(mtcars$wt, mtcars$mpg)
#plot(mtcars$wt, mtcars$mpg)
#mc_data <- mtcars[,2:length(mtcars)]
#round(cor(mc_data),2)
#Werkloosheid
#aantalwaarde <- c(dataTree$Werk$PJEUGDW_P$Stadsdeel$waarde)
#gebiedsnaam <- c(dataTree$Werk$PJEUGDW_P$Stadsdeel$gebiednaam)


