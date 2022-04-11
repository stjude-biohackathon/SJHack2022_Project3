###
#   File name : server.R
#   Author    : Hyunjin Kim
#   Date      : Apr 11, 2021
#   Email     : hyunjin.kim@stjude.org
#   Purpose   : Server part of the Shiny app
###

library(shiny)
library(ggplot2)

server <- function(input, output) {
  
  pca_values <- reactive({
    read.table(file = "C:/Users/hkim8/Documents/SJHack2022_Project3/data/1KG.inhouse.tsv",
               sep = "\t", header = TRUE,
               stringsAsFactors = FALSE, check.names = FALSE)
  })
  
  rv <- reactiveValues(
    dim1 = NULL,
    dim2 = NULL,
    unif = runif(500),
    chisq = rchisq(500, 2))
  
  observeEvent(input$pca_button, {
    rv$dim1 <- pca_values()[,input$dim1]
    rv$dim2 <- pca_values()[,input$dim2]
    })
  observeEvent(input$rechisq, { rv$chisq <- rchisq(500, 2) })
  
  output$descipt <- renderText({
    "Team Members: Wenan Chen, Wenjian Yang, Cody Ramirez, Wenchao Zhang, Hyunjin Kim
    \n
Summary: For fine scale identification of population/ethnicity,
we will use gnomAD's shared loadings from principal component analysis
to extract PCs for any new samples assuming VCF files have been generated,
and then use gnomAD's random forest classifiers to classify the population/ethnicity.
For visualization, will use TSNE/UMAP/PCA to visualize, and will use R Shiny
or related web-based technique to visualize the population structure either in 2D or 3D.
    \n
Race Info
AFR: African/African American
AMR: Latino/Admixed American
FIN: Finnish
NFE: Non-Finnish European
EAS: East Asian
SAS: South Asian
Other: Other (Population Not Assigned)"
  })
  
  output$pca_plot <- renderPlot({
    if(is.null(rv$dim1) && is.null(rv$dim2)) {
      plot_df <- data.frame(dim1=pca_values()[,"PC1"],
                            dim2=pca_values()[,"PC2"],
                            allLabels=pca_values()[,"allLabels"],
                            stringsAsFactors = FALSE, check.names = FALSE)
    } else {
      plot_df <- data.frame(dim1=pca_values()[,input$dim1],
                            dim2=pca_values()[,input$dim2],
                            allLabels=pca_values()[,"allLabels"],
                            stringsAsFactors = FALSE, check.names = FALSE)
    }
    
    ggplot(data = plot_df, aes(x=dim1, y=dim2)) +
      geom_point(aes_string(color="allLabels"), size = 2) +
      xlab(isolate(input$dim1)) +
      ylab(isolate(input$dim2)) +
      labs(color="Race") +
      theme_classic(base_size = 36) +
      theme(plot.title = element_text(hjust = 0, vjust = 0.5, size = 24))
  })
  output$chisq <- renderPlot({
    hist(rv$chisq, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a Chi Square distribution with two degree of freedom")
  })
}