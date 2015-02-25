# All scripts for the pubmed.evolution project

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

# Clean the Author-ity dataset
source('proj/pubmed.evolution/scripts/clean-authority.R')

# Construct a data.table of the PMIDs, with author counts, from Author-ity
source('proj/pubmed.evolution/scripts/pmids-authority.R')

# Construct a data.table of the PMIDs, with author counts, from the PubMed dump
source('proj/pubmed.evolution/scripts/pmids-pubmed.R')

# Extract the PMIDs shared by the PubMed dump and Author-ity
# that have the same numbers of authors associated with them
source('proj/pubmed.evolution/scripts/authority-pubmed-intersect.R')

# Create a data.table of author IDs with a list column of PMIDs
source('proj/pubmed.evolution/scripts/hel-authority.R')

# Identify the literatures on several topics
source('proj/pubmed.evolution/scripts/topic-pmids.R')

# Construct the networks for each topic
source('proj/pubmed.evolution/scripts/topic-networks.R')

# Compute basic stats for these networks
source('proj/pubmed.evolution/scripts/topic-stats.R')




# IN PROGRESS


# Convert the `mh` field in the PubMed dump to codes from the tree (INCOMPLETE)
#source('proj/pubmed.evolution/scripts/pubmed-mtrees.R')

# Construct and save a data.table of discipline sizes (INCOMPLETE)
#source('proj/pubmed.evolution/scripts/discipline-sizes.R')
