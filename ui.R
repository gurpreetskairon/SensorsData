#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#



# Define UI for application that draws a histogram
shinyUI(
    fluidPage(
        #theme = shinytheme("cyborg"),
        useShinyjs(),
        # title displaying my name
        title = "Exploratory Analysis of Sensors Data",
        # Application title
        h3("Dataset - Sensors Data"),
        h5(paste("# Variables in Sensors Data: ", variables)),
        h5(paste("# Observations in Sensors Data: ", records)),
        tabsetPanel(
            tabPanel("Summary",
                     h4("Listed Below is the Summary Of Sensors Data:"),
                     verbatimTextOutput(outputId = "Summary"),
            ),
            tabPanel("Raw Data",
                     h4("Listed Below is the Entire Sensors Data:"),
                     DT::dataTableOutput(outputId = "RawData")
            ),
            tabPanel("Mosaic Plot",
                     h4("A Mosaic Plot:"),
                     selectizeInput(inputId = "Variables", label = "Show variables:", choices = factorVariables, multiple = TRUE, selected = sample(factorVariables, 3)),
                     plotOutput(outputId = "Mosaic")
            ),
            tabPanel("Pairs Plot", 
                     h3("A ggplot2 Generalized Pairs Plot:"),
                     selectizeInput(inputId = "Pairs", label = "Select Variables:", choices = continuousVariables, multiple = TRUE, selected = sample(continuousVariables, 5)),
                     shinycssloaders::withSpinner(plotOutput(outputId = "ggPairs"))
            ),
            tabPanel("Correlation Chart", 
                     h4("A corrgram::corrgram Correlation Chart:"),
                     selectizeInput(inputId = "Correlation", label = "Select Variables:", choices = continuousVariables, multiple = TRUE, selected = sample(continuousVariables, 5)),
                     checkboxInput(inputId = "abs", label = "Uses absolute correlation", value = TRUE),
                     selectInput(inputId = "CorrMeth", label = "Correlation method", choices = c("pearson","spearman","kendall"), selected = "pearson"),
                     selectInput(inputId = "Group", label = "Grouping method", choices = list("none"=FALSE,"OLO"="OLO","GW"="GW","HC"="HC"), selected = "OLO"),
                     plotOutput(outputId = "Corrgram"),
                     
            ),
            tabPanel("Missing Data",
                     h4("Missing Data"),
                     selectizeInput(inputId = "MissingInput", label = "Show Variables:", choices = colnames(dat)[-1], multiple = TRUE, selected = sample(colnames(dat)[-1], 10)),
                     checkboxInput(inputId = "Cluster", label = "Cluster Missingness", value = FALSE),
                     shinycssloaders::withSpinner(plotOutput(outputId = "Missing")),
                     HTML("<br/>"),
                     h4("Missingness of Variables "),
                     shinycssloaders::withSpinner(plotOutput(outputId = "MissingVariables")),
                     HTML("<br/>"),
                     h4("Missingness Of Rows"),
                     shinycssloaders::withSpinner(plotOutput(outputId = "MissingCase")),
                     HTML("<br/>"),
                     h4("Pattern Of Missingness Using An Upset Plot"),
                     shinycssloaders::withSpinner(plotOutput(outputId = "MissingUpset")),
            ),
            tabPanel("Box Plot",
                     h4 = "Box Plot of the Data:",
                     plotOutput(outputId = "Boxplot"),
                     selectizeInput(inputId = "box", label = "Select Variables:", choices = continuousVariables, multiple = TRUE, selected = sample(continuousVariables, 5)),
                     checkboxInput(inputId = "standardise", label = "Center and Standardize", value = FALSE),
                     checkboxInput(inputId = "outliers", label = "Show Outliers", value = TRUE),
                     sliderInput(inputId = "range", label = "IQR Multiplier", min = 0, max = 5, step = 0.1, value = 1.5)
            ),
            tabPanel("Rising Value Chart",
                     h4("Rising Value Chart:"),
                     selectizeInput(inputId = "RisingInput", label = "Select Variables:", choices = continuousVariables, multiple = TRUE, selected = sample(continuousVariables, 5)),
                     plotOutput(outputId = "RisingValue")
            ),
            # tabPanel("Spectr",
            #          selectizeInput(inputId = "SpectraInput", label = "Select Variables:", choices = continuousVariables, multiple = TRUE, selected = sample(continuousVariables, 15)),
            #          plotOutput(outputId = "Spectra", height = "600px")         
            # ),
            tabPanel("Time Series",
                     h3("Time Series Data"),
                     selectizeInput(inputId = "TimeSeriesInput", label = "Select Variables:", choices = continuousVariables, multiple = TRUE, selected = sample(continuousVariables, 2)),
                     shinycssloaders::withSpinner(plotlyOutput(outputId = "TimeSeries"))
            )
        )
    )
)
