###
#   File name : runApp.R
#   Author    : Hyunjin Kim
#   Date      : Apr 11, 2021
#   Email     : hyunjin.kim@stjude.org
#   Purpose   : Start running the Shiny app
###
setwd("~/Downloads/SJHack2022_Project3-main/R")

library(shiny)

writeLines(paste("St Jude Biohackathon Shiny App Starting..."))

runApp("../R")
