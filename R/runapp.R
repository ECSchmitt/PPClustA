#' ShinyAPP displaing hierarchical clustering and PCA of gene expression data
#'
#' @return starts a shiny App to be displayed inside the webbrowser
#' @export
#'
#' @examples
runapp <- function(){

# Loading required libraries ----------------------------------------------
  library(shiny)
  library(ggfortify)
  library(cluster)
  library(dplyr)
  library(tibble)
  library(ggplot2)

# Data Import and processing -------------------------------------------------------------
  expression <- load_expr_data()
  genes <- extract_gene_names(expression)

  #Storing expression values as dataframe to use for more sophisticated PCA plots with ggplot2
  df_express <- as_tibble(expression) %>%
    add_column("cancertype" = Golub_Train$ALL.AML)

# ShinyUI -----------------------------------------------------------------
  ui <- fluidPage(

    #Tabset Panel to hold 2 Tabs
    tabsetPanel(

      #1st Tab
      tabPanel(
        title = "Hierachical Cluster Dendrogram", fluid = TRUE,
        sidebarLayout(
          sidebarPanel(
            sliderInput(
              inputId = "hcgnr",
              label = h5("Nr of genes to include"),
              value = 15,
              min = 1,
              max = 500
            ),
            selectInput(
              inputId = "hcdist",
              label = h5("Distance measure"),
              choices = c("euclidean" , "maximum" , "manhattan" , "canberra" , "binary")
            ),
            selectInput(
              inputId = "hcclust",
              label = h5("Clustering Method"),
              choices = c("single", "complete","average", "median", "centroid")
            ),
            downloadButton(
              outputId = "hclustplot")
          ),
          mainPanel(
            plotOutput("hcluster")
          )
        )
      ),

      # 2nd Tab
      tabPanel(
        title = "Principal Component Analysis",
        fluid = TRUE,
        sidebarLayout(
          sidebarPanel(
            sliderInput(
              inputId = "pcagnr",
              label = h5("Nr of genes to include"),
              value = 15,
              min = 1,
              max = 500
            ),
            selectInput(
              inputId = "pc1",
              label = h5("1st Prinicipal Component to display"),
              choices = c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15")
            ),
            selectInput(
              inputId = "pc2",
              label = h5("2nd Prinicipal Component to display"),
              selected = 2,
              choices = c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15")
            )
          ),
          mainPanel(
            fluidRow(
              splitLayout(cellWidths = c("50%","50%"),
                          plotOutput(outputId = "basicpca"),
                          plotOutput(outputId = "pca")
              )
            )
          )
        )
      )
    )
  )
# Shiny Server logic ------------------------------------------------------
  server <- function(input, output) {

    #Plotting hierarchical Clustering
    output$hcluster <- renderPlot({
      expression[,names(genes)[1:input$hcgnr]] %>%
        dist(method = input$hcdist) %>%
        hclust(method = input$hcclust) %>%
        plot()
    })

    #Handling download of hierarchical cluster plot
    output$hclustplot <- downloadHandler(
      filename = function(){
        paste("hclust","pdf", sep = ".")
      },
      content = function(file){
        pdf(file)
        expression[,names(genes)[1:input$hcgnr]] %>%
          dist(method = input$hcdist) %>%
          hclust(method = input$hcclust) %>%
          plot()
        dev.off()
      }
    )

    #Plotting basic PCA
    output$basicpca <- renderPlot({

      x <- expression[,names(genes)[1:input$pcagnr]] %>%
        prcomp(scale. = TRUE)

      plot(x$x[,as.numeric(input$pc1)],
           x$x[,as.numeric(input$pc2)],
           xlab = paste("PC", input$pc1),
           ylab = paste("PC", input$pc2))
    })

    #Plotting PCA
    output$pca <- renderPlot({
      df <- as_tibble(expression) %>%
        add_column("cancertype" = Golub_Train$ALL.AML)

      x <- expression[,names(genes)[1:input$pcagnr]] %>%
        prcomp()

      autoplot(x, data = df, colour = "cancertype") + theme_light()
    })


  }

# ShinyAPP starter --------------------------------------------------------
  shinyApp(ui = ui, server = server)

}
