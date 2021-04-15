fetch_data <- function(){
  library(golubEsets)
  library(tidyverse)

  #importing Golub Data into GlobalEnv
  data("Golub_Train")
  expr_Matrix <- expression <- Golub_Train %>%
    exprs() %>%                         #extracting expression values per gene from the Golub training data
    t() %>%                             #transposing expression matrix to one gene per column and one patient per row
    replace_zeros(1) %>%                #replacing 0 and x<0 with 1
    log2() %>%                          #Normalize matrix by log2()
    chg_rownames(Golub_Train$ALL.AML)   #changing the rownames from patient ID to cancertype

  #Sorting Genes by expression value from highest to lowest value and store the gene names
  #to obtain a ordering vector
  genes <- expr_Matrix %>%
    apply(2,var) %>%
    sort(decreasing = TRUE)

  }
