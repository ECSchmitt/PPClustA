#' Replaces zeros in a numerical matrix
#'
#' Replaces zeros in a numerical matrix with a given numerical value x. Was written to enable
#' the matrix operator to be used within a dplyr pipe
#'
#' @param matrix numerical matrix
#' @param x numerical value to replace zeros with
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' matrix %>%
#'   replace_zeros(x)
#' }
replace_zeros <- function(matrix, x){
  matrix[matrix <= 0] <- x
  return(matrix)
}
