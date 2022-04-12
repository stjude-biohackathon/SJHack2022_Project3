###
#   File name : ui.R
#   Author    : Hyunjin Kim
#   Date      : Apr 11, 2021
#   Email     : hyunjin.kim@stjude.org
#   Purpose   : UI part of the Shiny app
###

library(shiny)

pca_values <- read.table(file = "C:/Users/hkim8/Documents/SJHack2022_Project3/data/1KG.inhouse.tsv",
                         sep = "\t", header = TRUE,
                         stringsAsFactors = FALSE, check.names = FALSE)

pcs <- colnames(pca_values)[grep(pattern = "^PC", colnames(pca_values))]

ppls <- pca_values$Individual.ID

ui <- navbarPage(title = "SJHack2022_Project3",
                 tabPanel(title = "A web app for fine-scale population/ethnicity identification and visualization",
                          verbatimTextOutput("descipt")
                 ),
                 tabPanel(title = "Race Prediction",
                          fileInput("file1", "Choose VCF File", accept = ".vcf"),
                          selectInput('ref_file', 'Choose Reference', c("GRCh37", "GRCh38"),
                                      selected = "GRCh37"),
                          selectInput('dim1', 'Dimension 1', pcs,
                                      selected = pcs[1]),
                          selectInput('dim2', 'Dimension 2', pcs,
                                      selected = pcs[2]),
                          selectInput('person', "Person", ppls,
                                      selected = ppls[1]),
                          actionButton("pca_button", "Predict Race"),
                          br(),
                          br(),
                          verbatimTextOutput("pred"),
                          plotOutput("pca_plot")
                 )
                 
)
