###
#   File name : server.R
#   Author    : Hyunjin Kim
#   Date      : Apr 11, 2021
#   Email     : hyunjin.kim@stjude.org
#   Purpose   : Server part of the Shiny app
###

library(shiny)

server <- function(input, output) {
  
  rv <- reactiveValues(
    norm = rnorm(500), 
    unif = runif(500),
    chisq = rchisq(500, 2))
  
  observeEvent(input$reunif, { rv$unif <- runif(500) })
  observeEvent(input$rechisq, { rv$chisq <- rchisq(500, 2) })
  
  output$descipt <- renderText({
    "Team Members: Wenan Chen, Wenjian Yang, Cody Ramirez, Wenchao Zhang, Hyunjin Kim
    \n
Summary: For fine scale identification of population/ethnicity,
we will use gnomAD's shared loadings from principal component analysis
to extract PCs for any new samples assuming VCF files have been generated,
and then use gnomAD's random forest classifiers to classify the population/ethnicity.
For visualization, will use TSNE/UMAP/PCA to visualize, and will use R Shiny
or related web-based technique to visualize the population structure either in 2D or 3D."
  })
  
  output$norm <- renderPlot({
    hist(rv$norm, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a standard normal distribution")
  })
  output$unif <- renderPlot({
    hist(rv$unif, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a standard uniform distribution")
  })
  output$chisq <- renderPlot({
    hist(rv$chisq, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a Chi Square distribution with two degree of freedom")
  })
}
