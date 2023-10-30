#' Process Overlaps
#'
#' Calculates the overlap of digested fragments with genomic features
#'
#' @param frags.filt A filtered frags object
#'
#' @return Returns data frame object with number of fragments and
#' percent feature coverage for each genomic feature
#'
#' @export
#'

process_overlaps <- function(frags.filt) {

  frags.gr <- makeGRangesFromDataFrame(frags.filt)

  overlap.list <- purrr::map(annos, ~ subsetByOverlaps(.x, frags.gr)) # overlapping regions

  query.list <- purrr::map(annos, ~ length(.x)) # number of loci in annos

  number.overlap <- purrr::map(overlap.list, ~ length(.x))

  percent.coverage <- purrr::map2(number.overlap, query.list,  ~
                             .x / .y)

  list.obj <- list(`Features Overlapped` = number.overlap,
                   `Percent Features Covered` = percent.coverage)

  df <- data.frame(row.names = names(annos),
                   genomic_features = names(annos),
                   number_overlapped = unlist(list.obj$`Features Overlapped`),
                   percent_overlapped = unlist(list.obj$`Percent Features Covered`))

  return(df)

}
