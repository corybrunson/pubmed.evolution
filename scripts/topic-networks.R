# Identify the literature for each topic

# SENSITIVITY ANALYSIS: THREE WAYS TO DO THIS:
# 1. Papers with exact MeSH terms
# 2. Papers with MeSH terms or their children in the tree [CURRENT VERSION]
# 3. Papers with certain strings appearing among their MeSH terms

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

# Read in the topics list
source('proj/pubmed.evolution/code/topics.R')

# File names for PubMed dump
pubmed.files <- paste0(
    'data/medline/',
    list.files('data/medline/', 'medline12n*')
)

# Expand the topics vector to include children in the MeSH tree
topic.fam <- lapply(topics, mesh.family)

# Proceed along the files, building up a vector of PMIDs for each topic
topic.pmids <- lapply(topics, function(vec) c())
for(file in pubmed.files) {
    print(file)
    dat <- read.pubmed(file)
    for(i in 1:length(topics)) {
        re <- paste(paste0('(^|\\|)',
                           topic.fam[[i]],
                           '($|\\((Y|N)\\))'),
                    collapse = '|')
        topic.pmids[[i]] <- c(topic.pmids[[i]],
                              dat[grep(re, dat$mh), ]$pmid)
    }
}

# Save topic PMID lists
save(topic.pmids, file = 'proj/pubmed.evolution/data/topic.pmids.RData')

rm(list = ls())
