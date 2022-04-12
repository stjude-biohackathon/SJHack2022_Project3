###
#   File name : server.R
#   Author    : Hyunjin Kim
#   Date      : Apr 11, 2021
#   Email     : hyunjin.kim@stjude.org
#   Purpose   : Server part of the Shiny app
###

library(shiny)
library(ggplot2)
library(reticulate)
source("./functions.R")

use_condaenv(condaenv = "/opt/anaconda3/envs/r-reticulate", conda = "/opt/anaconda3/bin/conda")

source_python("../gnomADPCAndAncestry2.py")
output_path <- "../data/ALL_GRCh38_hail01.vcf.bgz.pc.ancestry.tsv.gz"

options(shiny.maxRequestSize = 30*1024^2)

server <- function(input, output) {
  
  pca_values <- reactive({
    df <- read.table(file = "../data/1KG.inhouse.tsv",
                     sep = "\t", header = TRUE,
                     stringsAsFactors = FALSE, check.names = FALSE)
    rownames(df) <- df[,"s"]
    return(df)
  })
  
  rv <- reactiveValues(
    file_path = NULL,
    dim1 = NULL,
    dim2 = NULL,
    pop = NULL,
    person = NULL,
    predictions = NULL)
  
  observeEvent(input$pca_button, {
    rv$dim1 <- pca_values()[,input$dim1]
    rv$dim2 <- pca_values()[,input$dim2]
    rv$pop <- pca_values()[,"pop"]
    rv$person <- input$person
    rv$pred <- pca_values()[input$person,"pop"]
    rv$file_path <- input$file1$datapath
    rv$ref_file <- input$ref_file
    # hail_run(rv$file_path, rv$ref_file, output_path)
    rv$predictions <- readHailPCAndAncestry(output_path)
    # rv$predictions <- read.table(file = output_path,
    #                              sep = "\t", header = TRUE,
    #                              stringsAsFactors = FALSE, check.names = FALSE)
    rownames(rv$predictions) <- rv$predictions[,"s"]
    
    rv$dim1 <- rv$predictions[,input$dim1]
    rv$dim2 <- rv$predictions[,input$dim2]
    rv$pop <- rv$predictions[,"pop"]
    rv$person <- rv$predictions[,"s"]
    rv$pred <-  rv$predictions[,"pop"]
  })
  
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
  
  output$pred <- renderText({
    lbl <- ""
    for(i in 1:length(rv$person)) {
      lbl <- paste0(lbl, rv$person[i], ": ", rv$pop[i], "\n")
    }
    # paste0("Race Prediction (",
    #        isolate(input$person), "): ",
    #        rv$pred, 
    #        "\n\n",
    #        "Probs:")
    return(lbl)
  })
  
  output$pca_plot <- renderPlot({
    if(is.null(rv$dim1) && is.null(rv$dim2)) {
      plot_df <- data.frame(dim1=pca_values()[,"PC1"],
                            dim2=pca_values()[,"PC2"],
                            pop=pca_values()[,"pop"],
                            stringsAsFactors = FALSE, check.names = FALSE)
    } else {
      plot_df <- data.frame(dim1=rv$dim1,
                            dim2=rv$dim2,
                            pop=rv$pop,
                            stringsAsFactors = FALSE, check.names = FALSE)
    }
    
    ggplot(data = plot_df, aes(x=dim1, y=dim2)) +
      geom_point(aes_string(color="pop"), size = 2) +
      xlab(isolate(input$dim1)) +
      ylab(isolate(input$dim2)) +
      labs(color="Race") +
      theme_classic(base_size = 36) +
      theme(plot.title = element_text(hjust = 0, vjust = 0.5, size = 24))
  })
}
