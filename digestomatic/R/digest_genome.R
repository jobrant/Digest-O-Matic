#' Performs in silico digestion of genomes
#'
#' This function performs an in silico digestion of BSgenomes based on chosen
#' type II restriction endonucleases
#'
#' @param genome String indicating the species to be loaded, e.g. 'human' will
#' load the package 'BSgenome.Hsapiens.UCSC.hg38'
#'
#' @param enzyme String indicating the enzyme to be used to detect sites
#'
#' @returns Returns data frame object with chromosome name, start position,
#' end position, and length of fragment for each gap between restriction digest sites
#'
#' @name digest_genome
#'
#' @export

data("neb.table")

digest_genome <- function(genome, enzyme) {

  genome.lib <- get_genome(genome)

  enz.table <- neb.table[grepl(x = neb.table$Enzyme, pattern = enzyme), ]

  frags.list <- list()

  for (i in seq_along(1:25)){#make function to get number of chromosomes for each species

    pdict <- PDict(x = enz.table$sequence,
                   tb.start = enz.table$tb_start,
                   tb.end = enz.table$tb_end)

    print(paste("Processing", seqnames(genome.lib)[i], 'of',
                genome.lib@metadata$genome, 'genome',
                'with enzyme', enzyme, sep = ' '))



    matchpdcit <- matchPDict(pdict = pdict, subject = genome.lib[[i]], fixed = 'subject')

    starts <- start(gaps(matchpdcit[[1]]))
    ends <- end(gaps(matchpdcit[[1]]))

    gr <- GRanges(seqnames = seqnames(genome.lib)[i], IRanges(start = starts, end = ends))

    frag.lengths <- width(gr)

    frags.list[[i]] <- data.frame(chr = seqnames(genome.lib)[i],
                                  start = starts,
                                  end = ends,
                                  length = frag.lengths)

  }

  frags <- dplyr::bind_rows(frags.list)

  data.table::fwrite(x = frags, file = paste(paste(genome.lib@metadata$genome, enzyme, sep = '_'), 'tsv', sep = '.'),
         sep = '\t', row.names = F, quote = F)

  return(frags)

}
