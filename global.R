library(shiny)
library(shinyjs)
library(corrgram)
library(visdat)
library(RColorBrewer)
library(datasets)
library(tidytext)
library(tidyverse)
library(ggplot2)
library(shinycssloaders)
library(ggfortify)
library(naniar)
library(ggfortify)
library(plotly)
library(autoplotly)




# load SensorsData.csv file 
dat <- read.csv("SensorsData.csv", header = TRUE)

dat$Date <- as.Date(dat$Date) 

# # variables in the data can be calculated using length() method
variables <- length(dat)

# # of records or rows could be calculated using the nrow() method
records <- nrow(dat)

factorVariables <- names(which(sapply(dat, class) == "factor"))[-1]
continuousVariables <- names(which(sapply(dat, class) != 'factor'))[-1 : -2]

