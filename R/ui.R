###
#   File name : ui.R
#   Author    : Hyunjin Kim
#   Date      : Apr 11, 2021
#   Email     : hyunjin.kim@stjude.org
#   Purpose   : UI part of the Shiny app
###

library(shiny)

ui <- navbarPage(title = "SJHack2022_Project3",
                 tabPanel(title = "A web app for fine-scale population/ethnicity identification and visualization",
                          verbatimTextOutput("descipt")
                 ),
                 tabPanel(title = "Uniform data",
                          plotOutput("unif"),
                          actionButton("reunif", "Resample")
                 ),
                 tabPanel(title = "Chi Squared data",
                          plotOutput("chisq"),
                          actionButton("rechisq", "Resample")
                 )
                 
)
