#' Choose a genome build
#'
#' This function adds the appropriate BSgenome package based on the users input
#'
#' @param genome String indicating the species to be loaded, e.g. 'human' will
#' load the package 'BSgenome.Hsapiens.UCSC.hg38'
#'
#' @returns Allows main digest function to use correct BSgenome package
#'
#' @export

get_genome <- function(genome) {

  if(tolower(genome) == 'human') {
    genome.lib <- Hsapiens
  } else if(tolower(genome) == 'mouse') {
    genome.lib <- Mmusculus
  }

  return(genome.lib)

}
