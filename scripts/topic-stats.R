# Compute basic stats on the topic-specific networks


# set working directory
if(file.exists('~/Documents')) setwd('~/Documents/CQM/')
setwd('PubMed/')
# load packages
pkgs <- c('pubmed.network')
for(pkg in pkgs) {
    if(!require(pkg, character.only = TRUE)) {
        install.packages(pkg)
        stopifnot(require(pkg, character.only = TRUE))
    }
}

# Load topic vectors
load('proj/pubmed.evolution/data/topic-pmids.RData')




rm(list = ls())
