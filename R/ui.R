###
#   File name : ui.R
#   Author    : Hyunjin Kim
#   Date      : Apr 11, 2021
#   Email     : hyunjin.kim@stjude.org
#   Purpose   : UI part of the Shiny app
###

library(shiny)

ui <- navbarPage(title = "Random generator",
                 tabPanel(title = "Normal data",
                          plotOutput("norm"),
                          actionButton("renorm", "Resample")
                 ),
                 navbarMenu(title = "Other data",
                            tabPanel(title = "Uniform data",
                                     plotOutput("unif"),
                                     actionButton("reunif", "Resample")
                            ),
                            tabPanel(title = "Chi Squared data",
                                     plotOutput("chisq"),
                                     actionButton("rechisq", "Resample")
                            )
                 )
)


