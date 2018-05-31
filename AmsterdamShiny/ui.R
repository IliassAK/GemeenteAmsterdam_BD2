div(class="container",
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"),
      tags$title("OpenData Amsterdam"),
      includeCSS("www/styles.css")
    ),
    div(class="header",
        img(src = "https://www.amsterdam.nl/publish/pages/828549/gasd_3_rgb.png"),
        div(class = "headertext",
            h3("OpenData Amsterdam")
        )
    ),
    navbarPage("", theme = shinytheme("yeti"), id="inTabset",
               # themas -------------
               tabPanel("Per gebied", value="pergebied",
                        div(class="row",
                            div(class="col-lg-12",
                                #p(class="",
                                div(class="col-lg-3",
                                    a(class="btn btn-sq-lg btn-danger action-button", id="but1",
                                      span(class="fa fa-handshake-o ", style="font-size:10em; text-center;"),
                                      helpText(class="btn-tiles-text", "Bestuur en ondersteuning"))
                                ),
                                div(class="col-lg-3",
                                    a(class="btn btn-sq-lg btn-danger action-button", id="but2",
                                      span(class="fa fa-lock", style="font-size:10em; text-center;"),
                                      helpText(class="btn-tiles-text", "Veiligheid"))
                                ),
                                div(class="col-lg-3",
                                    a(class="btn btn-sq-lg btn-danger action-button", id="but3",
                                      span(class="fa fa-users", style="font-size:10em; text-center;"),
                                      helpText(class="btn-tiles-text", "Bevolking"))
                                ),
                                div(class="col-lg-3",
                                    a(href="", class="btn btn-sq-lg btn-danger action-button", id="but4",
                                      span(class="fa fa-car", style="font-size:10em; text-center;"),
                                      helpText(class="btn-tiles-text", "Verkeer"))
                                )
                            )
                        ),
                        div(class="row",
                            div(class="col-lg-12",
                                p(class="",
                                  div(class="col-lg-3",
                                      a(class="btn btn-sq-lg btn-danger action-button", id="but5",
                                        span(class="fa fa-building", style="font-size:10em;"),
                                        helpText(class="btn-tiles-text", "Onderwijs")
                                      )
                                  ),
                                  div(class="col-lg-3",
                                      a(class="btn btn-sq-lg btn-danger action-button", id="but6",
                                        span(class="fa fa-sign-language", style="font-size:10em;"),
                                        helpText(class="btn-tiles-text", "Cultuur")
                                      )
                                  ),
                                  div(class="col-lg-3",
                                      a(class="btn btn-sq-lg btn-danger action-button", id="but7",
                                        span(class="fa fa-area-chart", style="font-size:10em;"),
                                        helpText(class="btn-tiles-text", "Diversititeit")
                                      )
                                  ),
                                  div(class="col-lg-3",
                                      a(href="", class="btn btn-sq-lg btn-danger action-button", id="but8",
                                        span(class="fa fa-battery-three-quarters", style="font-size:10em;"),
                                        helpText(class="btn-tiles-text", "Duurzaamheid")
                                      )
                                  )
                                )
                            )
                        ),
                        div(class="row",
                            div(class="col-lg-12",
                                p(class="",
                                  div(class="col-lg-3",
                                      a(class="btn btn-sq-lg btn-danger action-button", id="but9",
                                        span(class="fa fa-suitcase", style="font-size:10em;"),
                                        helpText(class="btn-tiles-text", "Werk")
                                      )
                                  ),
                                  div(class="col-lg-3",
                                      a(class="btn btn-sq-lg btn-danger action-button", id="but10",
                                        span(class="fa fa-heartbeat", style="font-size:10em;"),
                                        helpText(class="btn-tiles-text", "Welzijn en zorg")
                                      )
                                  ),
                                  div(class="col-lg-3",
                                      a(class="btn btn-sq-lg btn-danger action-button", id="but11",
                                        span(class="fa fa-line-chart", style="font-size:10em;"),
                                        helpText(class="btn-tiles-text", "Bevolking leeftijd")
                                      )
                                  ),
                                  div(class="col-lg-3",
                                      a(href="", class="btn btn-sq-lg btn-danger action-button", id="but12",
                                        span(class="fa fa-eur", style="font-size:10em;"),
                                        helpText(class="btn-tiles-text", "Inkomen")
                                      )
                                  )
                                )
                            )
                        ),
                        div(class="row",
                            div(class="col-lg-12",
                                p(class="",
                                  div(class="col-lg-3",
                                      a(class="btn btn-sq-lg btn-danger action-button", id="but13",
                                        span(class="fa fa-home", style="font-size:10em;"),
                                        helpText(class="btn-tiles-text", "Wonen")
                                      )
                                  ),
                                  div(class="col-lg-3",
                                      a(class="btn btn-sq-lg btn-danger action-button", id="but14",
                                        span(class="fa fa-futbol-o", style="font-size:10em;"),
                                        helpText(class="btn-tiles-text", "Sport")
                                      )
                                  ),
                                  div(class="col-lg-3",
                                      a(class="btn btn-sq-lg btn-danger action-button", id="but15",
                                        span(class="fa fa-thumbs-o-up", style="font-size:10em;"),
                                        helpText(class="btn-tiles-text", "Participatie")
                                      )
                                  ),
                                  div(class="col-lg-3",
                                      a(href="", class="btn btn-sq-lg btn-danger action-button", id="but16",
                                        span(class="fa fa-shopping-cart", style="font-size:10em;"),
                                        helpText(class="btn-tiles-text", "Bedrijvigheid winkels")
                                      )
                                  )
                                )
                            )
                        ), 
                        div(class="row",
                            div(class="col-lg-12",
                                p(class="",
                                  div(class="col-lg-3",
                                      a(class="btn btn-sq-lg btn-danger action-button", id="but17",
                                        span(class="fa fa-bank", style="font-size:10em;"),
                                        helpText(class="btn-tiles-text", "Bedrijvigheid functie")
                                      )
                                  ),
                                  div(class="col-lg-3",
                                      a(class="btn btn-sq-lg btn-danger action-button", id="but18",
                                        span(class="fa fa-institution", style="font-size:10em;"),
                                        helpText(class="btn-tiles-text", "Bedrijvigheid sectie")
                                      )
                                  ),
                                  div(class="col-lg-3",
                                      a(class="btn btn-sq-lg btn-danger action-button", id="but19",
                                        span(class="fa fa-info", style="font-size:10em;"),
                                        helpText(class="btn-tiles-text-2", "Dienstverlening en informatie")
                                      )
                                  ),
                                  div(class="col-lg-3",
                                      a(href="", class="btn btn-sq-lg btn-danger action-button", id="but20",
                                        span(class="fa fa-globe", style="font-size:10em;"),
                                        helpText(class="btn-tiles-text", "Openbare ruimte")
                                      )
                                  )
                                )
                            )
                        ),
                        div(class="row",
                            div(class="col-lg-12",
                                p(class="",
                                  div(class="col-lg-3",
                                      a(href="", class="btn btn-sq-lg btn-danger action-button", id="but21",
                                        span(class="fa fa-cubes", style="font-size:10em;"),
                                        helpText(class="btn-tiles-text", "Bedrijvigheid")
                                      )
                                  ),
                                  div(class="col-lg-3",
                                      a(href="", class="btn btn-sq-lg btn-danger action-button", id="but22",
                                        span(class="fa fa-globe", style="font-size:10em;"),
                                        helpText(class="btn-tiles-text", "Leefbaarheid")
                                      )
                                  )
                                )
                            )
                        )
                        
               ),
               # kaart ------------
               tabPanel("Map", id="maptab", value="mappanel",
                        div(class="row",
                            div(class="col-md-9 mapcol",
                                leafletOutput("map", width="100%", height="500px")
                            ),
                            div(class="col-md-3 datacol",
                                div(class="col-lg-12",
                                    a(class="btn btn-sq-lg btn-danger action-button", id="butBack",
                                      htmlOutput("iconBackButton"),
                                      helpText(class="btn-tiles-text-small", textOutput("textBackButton"),
                                               span(class="fa fa-arrow-left", style="font-size:2em;")
                                      )
                                    )
                                )
                            ),
                            
                            div(class="col-md-3 datacol", 
                                hr(),
                                h4("Geselecteerd gebied"),
                                tableOutput("mapdataTable")),
                            
                            div(class="row bg-light",
                                div(class="col-md-4",
                                    selectInput(inputId ="indicator",
                                                label = "Indicator",
                                                choices = c(emptyInputString), 
                                                selected = NULL,
                                                multiple = FALSE
                                    )
                                ),
                                div(class="col-md-4",
                                    selectInput(inputId ="level",
                                                label = "Niveau",
                                                choices = c(emptyInputString),
                                                selected = NULL,
                                                multiple = FALSE
                                    )
                                ),
                                div(class="col-md-4",
                                    sliderInput(inputId = "year",
                                                label = "Jaar",
                                                min=0,
                                                max=0,
                                                value=0,
                                                step=1,
                                                animate = animationOptions(
                                                  interval = 1500,
                                                  loop = FALSE
                                                ))
                                )
                            ),
                            div(class="row", 
                                div(class = "col-lg-12",
                                    textOutput("metadataText")
                                )
                            ),
                            hr(),
                            div(class="row",
                                div(class="col-lg-12",
                                    selectInput(inputId = "selectedAreaSelect",
                                                label = "gebied(en)",
                                                choices = c(emptyInputString), 
                                                selected = NULL,
                                                multiple = TRUE
                                    ),
                                    plotlyOutput("histogram")
                                )
                            )
                        )
               ),
               # per indicator -----
               tabPanel("Per indicator",
                        div(class="row",
                            div(class="col-md-9 mapcol",
                                leafletOutput("mapComparisons", width="100%", height="500px")
                            ),
                            div(class="col-md-3 datacol",
                                selectInput(
                                  inputId = "PerIndicator",
                                  label = "indicator(en)",
                                  choices = getThemeLabeledIndicatorList(),
                                  selected = NULL,
                                  multiple = TRUE,
                                  width = "90%"
                                ),
                                selectInput(
                                  inputId = "levelPerIndicator",
                                  label = "Niveau",
                                  choices = c(emptyInputString),
                                  selected = NULL,
                                  multiple = FALSE,
                                  width = "90%"
                                ),
                                h4("Geselecteerd gebied"),
                                tableOutput("comparisonMapdataTable")
                            )
                        ),
                        div(class="row",
                            div(class="col-lg-12",
                                plotlyOutput("histogram1")
                            )
                        )
               ),
               # data viewer ----------------
               tabPanel("Data weergave",
                        selectInput(inputId = "dataViewerIndicator",
                                    label = "indicator(en)",
                                    choices = getThemeLabeledIndicatorList(), 
                                    selected = NULL,
                                    multiple = TRUE,
                                    width = "90%"
                        ),
                        actionButton("dataViewerSubmitButton","Toon in tabel"),
                        downloadButton("downloadViewerData", "Download"),
                        hr(),
                        DT::dataTableOutput("tabledata")
               ),
               
               #leefbaarheid-----------------
               tabPanel("Leefbaarheid", id="leefbaarheidtab",
                        div(class="row",
                            div(class="col-md-9 mapcol",
                                leafletOutput("leefbaarheidMap", width="100%", height="500px")
                            ),
                            div(class="col-md-3 datacol",
                                selectInput(inputId ="levelLeefbaarheid",
                                            label = "Niveau",
                                            choices = c(emptyInputString),
                                            selected = NULL,
                                            multiple = FALSE
                                ),
                                h4("Geselecteerd gebied"),
                                tableOutput("leefbaarheidMapdataTable")
                            )
                        ),
                        div(class="row",
                            div(class="col-md-4 leefbaarheidCol",
                                h4("Vergelijking gebieden"),
                                plotlyOutput("chartVergelijkingLeefbaarheid")
                            ),
                            div(class="col-md-4 leefbaarheidCol",
                                h4("Leefbaarheid score"),
                                htmlOutput("leefbaarheidText"),
                                tableOutput("leefbaarheidTable")
                            ),
                            div(class="col-md-4 leefbaarheidCol",
                                h4("Afwijking van gemiddelde"),
                                plotlyOutput("chartLeefbaarheid")
                            )
                        )
               ),
               tabPanel("Info",
                        fluidRow(
                          column(12,
                                 includeMarkdown("tabAbout//info.md")
                          )
                        )
               ),
               #Einde Sectie informatie
               #
               #
               #Sectie Correlatie: Uitbreiding op bestaande applicatie
               tabPanel("Correlatie",
                        div(class="row",
                            div(class="col-md-6 mapcol",
                                
                                selectInput(
                                  inputId = "correlationLevel",
                                  label = "Niveau",
                                  choices = c("", "Stadsdeel"),
                                  selected = "Noord",
                                  multiple = FALSE,
                                  width = "90%"
                                ),
                                
                                leafletOutput(
                                  "mapCorrelations", 
                                  width="100%",
                                  height="500px")
                            ),
                            
                            
                            div(class="col-md-6 datacol", top="500px",
                                br(),
                                
                                tags$h5("Geselecteerd gebied:", left = "100px"),
                                uiOutput("code"),
                                hr(),
                                
                                
                                selectInput(
                                  inputId = "CorrelationElem1",
                                  label = "Indicator(en)",
                                  choices = getThemeLabeledIndicatorList(),
                                  selected = NULL,
                                  multiple = FALSE,
                                  width = "90%"
                                ),
                                
                                sliderInput(
                                  inputId = "correlatieGrens",
                                  label="Correlatie grens", 
                                  min = 0, 
                                  max = 1, 
                                  value = c(0,1),
                                  step = 0.1,
                                  width ="90%"
                                ),
                                checkboxInput(
                                  "filterCorrelation", 
                                  "Filter soortgelijke categorien", 
                                  FALSE
                                ),
                                hr(),
                                selectInput(
                                  inputId = "CorrelationElem2",
                                  label = "Correleerde indicatoren",
                                  choices = c(""),
                                  selected = NULL,
                                  multiple = FALSE,
                                  width = "90%"
                                )
                            )
                        ),
                        
                        div(class="row",
                            div(class="col-md-6 datacol",
                                plotlyOutput("CorrelationGraph1")
                            ), 
                            
                            div(class="col-md-6 datacol",
                                plotlyOutput("CorrelationGraph2")
                            )
                        )
                        
               )
               #Einde Sectie correlatie
    ),
    # Disclaimer
    htmlOutput("disclaimer")
)
