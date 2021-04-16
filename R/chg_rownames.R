#' Changes rownames of a matrix
#'
#' Function takes a vector containing names and a matrix and exchanges
#' the rownames of the matrix with the ones provided in the names vector.
#' Note that the row dimension of the matrix has to be equal to the length of the
#' names vector. The function was written to enable a rownames replacement in dplyr's pipe.
#'
#' @param matrix any matrix of dimension n*m
#' @param newnames a character vector of length n
#'
#' @return the given matrix with changed rownames
#' @export
#'
#' @examples
#' \dontrun{
#' matrix %>%
#'   chg_rownames(newnames)
#' }
chg_rownames <- function(matrix, newnames){
  rownames(matrix) <- newnames
  return(matrix)
}
