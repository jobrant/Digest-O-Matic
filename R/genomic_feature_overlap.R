#' Genomic Feature Overlap
#'
#' Finds overlap of size selected digest fragments with genomic features; calculates percent coverage
#'
#' @param genome String indicating the species to be loaded, e.g. 'human' will
#' load the package 'BSgenome.Hsapiens.UCSC.hg38'
#'
#' @param digest Object containing the output of get_digest()
#'
#' @param sites Sequence to be scanned for (usually sites that can be probed
#' for chromatin accessibility); can take more than one entry;
#' e.g. sites = c('HCG', 'GCH')
#'
#' @return Returns data frame object with chromosome name, start position,
#' end position, length of fragment, and one column for each sites with the
#' number of sites per fragment
#'
#' @export
#'
