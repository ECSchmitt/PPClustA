#' Creates a ordered list of colnames of a given Matrix
#'
#' This function orders the columns of a matrix by variance starting with the highest within column variance
#' left to the lowest within column variance on the right.
#'
#' @param matrix a numerical matrix
#'
#' @return vector containing colnames
#' @export
#'
#' @examples
#' \dontrun{
#' colnames <- matrix %>%
#'   extract_gene_names()
#' }
extract_gene_names <- function(matrix){

  #Sortes columns by column variance starting with highest var left to lowest war right and
  #stores ordered colnames in a character vector
  colnames <- matrix %>%
    apply(2,var) %>%
    sort(decreasing = TRUE)

  return (colnames)
  }
