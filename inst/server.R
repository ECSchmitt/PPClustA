server <- function(input, output) {

  #building hierarchical cluster plot
  output$hcluster <-  renderPlot({

    expr_Matrix[,names(genes)[1:input$gnr]] %>%
      dist(method = input$distm) %>%
      hclust(method = input$cmeth) %>%
      plot()
  })

  #building heatmap
  output$hmap <- renderPlot({
    expr_Matrix[,names(genes)[1:input$gnr]] %>%
      heatmap()
  })

  #basic PCA blot with chooseable principal components and gene numbers
  output$basicpca <- renderPlot({

    x <- expr_Matrix[,names(genes)[1:input$gnr]] %>%
      prcomp(scale. = TRUE)

    plot(x$x[,input$one],
         x$x[,input$two],
         xlab = paste("PC", input$one),
         ylab = paste("PC", input$two))
  })

  #PCA plot colourised displaying loadings & cancertypes fetched from the df_expression dataframe
  output$pca <- renderPlot({

    x <- expr_Matrix[,names(genes)[1:input$gnr]] %>%
      prcomp(scale. = TRUE)

    autoplot(x, data = df_express,
             colour = "cancertype",
             loadings = TRUE,
             loadings.colour = "lightgrey",
    ) + theme_bw()
  })

  #framed clusters reactive to numbers of clusters given
  output$clusterrange <- renderPlot({
    x <- expr_Matrix[,names(genes)[1:input$gnr]] %>%
      prcomp(scale. = TRUE)
    autoplot(pam(x$x,input$clustNr), frame = TRUE, frame.type = "norm")+
      theme_bw()
  })

  #Ploting Variances covered by each PC
  output$variances <- renderPlot({
    p <- expr_Matrix[,names(genes)[1:input$gnr]] %>%
      prcomp(scale. = TRUE)
    plot(p, type = "lines", main = "Variance per PC")
  })

}
