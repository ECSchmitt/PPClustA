fluidPage(

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
      )
    ),
    position = "left",
    fluid = FALSE
  )
)
