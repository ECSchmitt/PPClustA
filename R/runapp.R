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

  # Shiny UI ----------------------------------------------------------------
  ui <- fluidPage(

    titlePanel("Visualisation of the Golub et al. Gene expression Set"),
    sidebarLayout(
      sidebarPanel(

        sliderInput(
          inputId = "gnr",
          label = "How Many genes would you like to include?",
          value = 15,
          min = 1,
          max = 500
        ),

        p("Select the parameters to calculate a hierarchical clustered Dendrogram"),
        selectInput(
          inputId = "distm",
          label = "Distance Measure ",
          choices = c("euclidean" , "maximum" , "manhattan" , "canberra" , "binary")
        ),
        selectInput(
          inputId = "cmeth",
          label = "Clustering Method",
          choices = c("single", "complete","average", "median", "centroid")
        ),

        p("Select the two Principal Components you'd like to display"),
        sliderInput(
          inputId = "one",
          label = "First PC",
          value = 1,
          min = 1,
          max = 15
        ),
        sliderInput(
          inputId = "two",
          label = "Second PC",
          value = 2,
          min = 1,
          max = 15
        ),

        sliderInput(
          inputId = "clustNr",
          label = "Number of Clusters to find",
          value = 1,
          min = 1,
          max = 5
        )

      ),
      mainPanel(
        tabsetPanel(
          tabPanel(
            title = "Hierachical Cluster Dendrogram",
            plotOutput("hcluster")
          ),
          tabPanel(
            title = "Heatmap",
            plotOutput("hmap")
          ),
          tabPanel(
            title = "Principal Component Analysis",
            fluidRow(
              splitLayout(cellWidths = c("50%","50%"),
                          plotOutput(outputId = "basicpca"),
                          plotOutput(outputId = "pca")
              )
            ),
            fluidRow(
              splitLayout(cellWidths = c("50%","50%"),
                          plotOutput(outputId = "variances"),
                          plotOutput(outputId = "clusterrange")
              )
            )
          )
        ),
        downloadButton(
          outputId = "VisSum",
          label = "VisualSummary"
        )
      ),
      position = "left",
      fluid = FALSE
    )
  )



  # Shiny Server logic ------------------------------------------------------
  server <- function(input, output) {

    #building hierarchical cluster plot
    output$hcluster <-  renderPlot({

      expression[,names(genes)[1:input$gnr]] %>%
        dist(method = input$distm) %>%
        hclust(method = input$cmeth) %>%
        plot()

    })

    #building heatmap
    output$hmap <- renderPlot({
      expression[,names(genes)[1:input$gnr]] %>%
        heatmap()
    })

    #basic PCA blot with choseable principal components and gene numbers
    output$basicpca <- renderPlot({

      x <- expression[,names(genes)[1:input$gnr]] %>%
        prcomp(scale. = TRUE)

      plot(x$x[,input$one],
           x$x[,input$two],
           xlab = paste("PC", input$one),
           ylab = paste("PC", input$two))
    })

    #PCA plot colourised displaying loadings & cancertypes fetched from the df_expression dataframe
    output$pca <- renderPlot({
      x <- expression[,names(genes)[1:input$gnr]] %>%
        prcomp(scale. = TRUE)

      autoplot(x, data = df_express,
               colour = "cancertype",
               loadings = TRUE,
               loadings.colour = "lightgrey",
      ) +
        theme_bw()
    })

    #Plots framed clusters reactive to numbers of clusters given
    output$clusterrange <- renderPlot({
      x <- expression[,names(genes)[1:input$gnr]] %>%
        prcomp(scale. = TRUE)

      autoplot(pam(x$x,input$clustNr), frame = TRUE, frame.type = "norm")+
        theme_bw()
    })

    #Ploting Variances covered by each PC
    output$variances <- renderPlot({
      p <- expression[,names(genes)[1:input$gnr]] %>%
        prcomp(scale. = TRUE)

      plot(p, type = "lines", main = "Variance per PC")
    })

  }

  # ShinyAPP starter --------------------------------------------------------
  shinyApp(ui = ui, server = server)

}
