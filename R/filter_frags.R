#' Filter Digested Fragments
#'
#' Simply filters digested fragments based on user input paramaters
#'
#' @param frags input frags data frame; output of digest_genome()
#'
#' @param min minimum length of fragments to be included. Shorter fragments will be discarded
#'
#' @param max maximum length of fragments to be included. Larger fragments will be discarded
#'
#' @return Returns a filtered frags data frame
#'
#' @export

filter_frags <- function(frags, min, max) {

  frags.filt <- frags[frags$length >= min & frags$length <= max, ]

  return(frags.filt)

}



