#' Get Sites
#'
#' Finds the location and number of sites of interest
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

get_sites <- function(genome, digest, sites) {

  frags <- digest

  chromosomes <- unique(frags$chr)

  frags.list <- list()

  for (i in seq_along(chromosomes)) {

    genome.lib <- get_genome(genome)

    frags.list[[i]] <- frags[frags$chr == chromosomes[i], ]

    gr <- GRanges(seqnames = frags.list[[i]]$chr, IRanges(start = frags.list[[i]]$start,
                                                          end = frags.list[[i]]$end))

    chrom <- DNAStringSet(genome.lib[[i]])
    names(chrom) <- seqnames(genome.lib)[[i]]

    chrom.seq <- getSeq(x = chrom, gr)

    for (j in seq_along(sites)) {

      frag.site.counts <- vcountPattern(pattern = sites[j], subject = chrom.seq, fixed = 'subject')

      frags.list[[i]][, sites[j]] <- frag.site.counts

    }

  }

  frags <- dplyr::bind_rows(frags.list)

  return(frags)

}
