#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$Summary <- renderPrint({
        summary(dat)
    })
    
    output$RawData <- DT::renderDataTable({
        DT::datatable(data = as.data.frame(dat))
    })

    output$Mosaic <- renderPlot({
        formula <- as.formula(paste("~",paste(input$Variables, collapse = " + ")))
        vcd::mosaic(formula, data = dat[factorVariables],
                    main = "Discrete Variables", shade = TRUE, legend = TRUE)
    })
    
    output$ggPairs <- renderPlot({
       GGally::ggpairs(data = dat[input$Pairs], title = "Pairs of Sensors data")
  #      GGally::ggpairs(data = dat[input$Pairs],  mapping = ggplot2::aes(colour = sample(input$Pairs, 1)), title = "Pairs of Sensors data")
    })
    
    output$Corrgram <- renderPlot({input$Pairs
        corrgram(dat[input$Correlation], 
                 order = input$Group, 
                 abs = input$abs, 
                 cor.method = input$CorrMeth,
                 text.panel = panel.txt,
                 main = "Correlation of Sensors data")
    })
    
    output$Missing <- renderPlot({
        vis_miss(dat[input$MissingInput], cluster = input$Cluster)
    })
    
    output$MissingVariables <- renderPlot({
          #gg_miss_upset(dat[input$MissingInput])
      gg_miss_var(dat)
    })
    
    output$MissingCase <- renderPlot({
      #gg_miss_upset(dat[input$MissingInput])
      gg_miss_case(dat)
    })
    
    output$MissingUpset <- renderPlot({
      #gg_miss_upset(dat[input$MissingInput])
      gg_miss_upset(dat)
    })
    
    
    output$Boxplot <- renderPlot({
        data <- as.matrix(dat[input$box])
        data <- scale(data, center = input$standardise, scale = input$standardise)
        boxplot(data, use.cols = TRUE, notch = FALSE, varwidth = FALSE,  
                horizontal = FALSE, outline = input$outliers, 
                col = brewer.pal(n = dim(dat)[2], name = "RdBu"),
                range = input$range, main = "Boxplots of Sensors data")
    })

    output$RisingValue <- renderPlot({
        cols <- c(input$RisingInput)
        d <- dat[cols]  # select the definitely continuous columns
        for (col in 1:ncol(d)) {
            d[,col] <- d[order(d[,col]),col] #sort each column in ascending order
        }
        d <- scale(x = d, center = TRUE, scale = TRUE)  # scale so they can be graphed with a shared Y axis
        mypalette <- rainbow(ncol(d))
        matplot(x = seq(1, 100, length.out = nrow(d)), y = d, type = "l", xlab = "Percentile", ylab = "Values", lty = 1, lwd = 2, col = mypalette, main = "Rising Value Chart")
        legend(legend = colnames(d), x = "topleft", y = "top", lty = 1, lwd = 2, col = mypalette, ncol = round(ncol(d)^0.3))
    })
    
    # Interactive Time Series plot
    output$TimeSeries <- renderPlotly({
      autoplotly(ts(dat[input$TimeSeriesInput]))
    })

    output$Spectra <- renderPlot({
      matplot(t(dat[input$SpectraInput]), type = "l", ylab = "-log(R)", xaxt = "n", main = "Sensors Data spectra")
      ind <- pretty(seq(from = 900, to = 1700, by = 2))
      ind <- ind[ind >= 900 & ind <= 1700]
      ind <- (ind - 898) / 2
      axis(1, ind, colnames(dat[input$SpectraInput])[ind])
    })
})
