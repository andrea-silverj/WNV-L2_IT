#!/usr/bin/env Rscript

setwd("/nfs1/silverja/wnv/data_retrieval_ncbi") # Set the working directory
library("rentrez")
set_entrez_key("30825015ea1c138f89865295c5ad1a5d0308")

my_ekey <- Sys.getenv("ENTREZ_KEY")
cat("My Entrez key is set and corresponds to the following code:", my_ekey)

wnv_ncbi_search <- entrez_search(db="nucleotide", term="West Nile virus[Organism] & 200:13000[SLEN]",retmax="10000", use_history=TRUE)

nterms <- length(wnv_ncbi_search$ids)

cat("\nThe NCBI search resulted in", nterms, "terms")

cat("\nDownload in progress...\n")

for(seq_start in seq(1,nterms,50)){
    Sys.sleep(0.1)
    recs <- entrez_fetch(db="nucleotide", web_history=wnv_ncbi_search$web_history,
                         rettype="fasta", retmax=50, retstart=seq_start)
    cat(recs, file="wnv.fasta", append=TRUE)
    cat("\n", seq_start+49, "sequences downloaded, please wait...\r")
}

write(wnv_ncbi_search$ids, file="wnv_ncbi_search.txt")
