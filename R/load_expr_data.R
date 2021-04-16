#' Creates gene expression matrix from the Golub data
#'
#' Calling this function will load the 'golubEsets' and 'tidyverse' libraries.
#' Furthermore, the Golub_Train matrix with gene espression data will be loaded and transposed.
#' After transposing it, zeros will be replaced by ones and the expression values are normalised
#' by applying log2. Afterwards, rownames of the expression matrix are changed from patient IDs
#' to the corresponding cancertypes.
#'
#' @return normalized expression matrix of Golub data
#' @export
#'
#' @examples
#' \dontrun{
#' library("Golub_Train")
#' data("Golub_Train")
#' expression_Matrix <- Golub_Train
#' return(expression_Matrix)
#' }
load_expr_data <- function(){
  library(golubEsets)

  #importing Golub Data into GlobalEnv
  data("Golub_Train")
  expr_Matrix <- expression <- Golub_Train %>%
    exprs() %>%                         #extracting expression values per gene from the Golub training data
    t() %>%                             #transposing expression matrix to one gene per column and one patient per row
    replace_zeros(1) %>%                #replacing 0 and x<0 with 1
    log2() %>%                          #Normalize matrix by log2()
    chg_rownames(Golub_Train$ALL.AML)   #changing the rownames from patient ID to cancertype

  return (expr_Matrix)
  }
