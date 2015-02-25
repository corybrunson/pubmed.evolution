# Intersect the PubMed data with the Author-ity data

# set working directory
if(file.exists('~/Documents')) setwd('~/Documents/CQM/')
setwd('PubMed/')
# load packages
pkgs <- c('pubmed.network', 'snow', 'parallel')
for(pkg in pkgs) {
    if(!require(pkg, character.only = TRUE)) {
        install.packages(pkg)
        library(pkg, character.only = TRUE)
    }
}

# source code
source('proj/pubmed.evolution/code/medline2R.R')

# load data.tables
load(file = 'proj/pubmed.evolution/data/pmids-authority.RData')
load(file = 'proj/pubmed.evolution/data/pmids-pubmed.RData')

# Identify PMIDs in only one source
#pmid.int <- pmid.dt1[pmid.dt2, nomatch = 0]
pmid.mrg <- merge(pmid.dt1, pmid.dt2, all = TRUE)
pmid.ex1 <- pmid.mrg[is.na(count.y)]
pmid.ex2 <- pmid.mrg[is.na(count.x)]
pmid.int <- pmid.mrg[!(is.na(count.x) | is.na(count.y))]

# Identify PMIDs in both databases with different numbers of authors
pmid.dis <- pmid.int[count.x != count.y]
pmid.use <- pmid.int[count.x == count.y]

# Save a vector of row numbers for these PMIDs in the PubMed data (to avoid)
pubmed.use <- which(pmid.dt2$pmid %in% pmid.use$pmid)

save(pmid.ex1, pmid.ex2, pmid.dis, pmid.use, pubmed.use,
     file = 'proj/pubmed.evolution/data/pmid-intersect.RData')

rm(list = ls())
