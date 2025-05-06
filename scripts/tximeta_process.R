require("tximeta")
require("data.table")
require("dplyr")

# this script reads in all SALMON quant files
# creates a SummarizedExperiment object
# adds in the metadata
# summarizes transcript abundance to gene abundance
# this code is heavily inspired by
# https://github.com/AlexsLemonade/training-modules/blob/master/RNA-seq/02-gastric_cancer_tximeta.Rmd


#' Read in the Quant files
#'
#' @param quant_dir The directory containing all salmon quant files
#' the files should be within a directory titled by the sample id
#' @return a dataframe of the sample name and full file path
read_quant_files <- function(quant_dir){

    res_files = list.files(quant_dir,
                            pattern=".sf",
                            full.names = TRUE,
                            recursive=T)

    # split on the path, we assume it is the name of the folder the sf file is located
    sample_names = unlist(lapply(strsplit(res_files, "/"),
                            function(x) x[[length(x)-1]]))

    # now make the dataframe
    tximeta_df = data.frame(files = res_files,
                            names = sample_names)
    return(tximeta_df)
}


#' Transcript to Genes
#'
#' @param metadata_df The file with all needed metadata
#' to understand the counts
#' @param a dataframe of the sample name and full file path for tximeta
#' @return a Summarizedexperiment of gene abundance estimation
process_tx2gene <- function(quant_df){

    # now read in
    txi_data <- tximeta(quant_df)

    # summarize
    gene_summarized <- summarizeToGene(txi_data)

    return(gene_summarized)
}


### read in arguements
args = commandArgs(trailingOnly=TRUE)
quant_dir = args[1]
outdir = args[2]

quant_df <- read_quant_files(quant_dir)
gene_summarized <- process_tx2gene(quant_df)

txi_out_file = file.path(outdir, "salmon_gene_quant.RDS")
readr::write_rds(gene_summarized, file = txi_out_file)
