# All scripts for the pubmed.evolution project

# Clean the Author-ity dataset
source('scripts/clean-authority.R')

# Construct a data.table of the PMIDs, with author counts, from the PubMed dump
source('scripts/pmids-pubmed')

# Construct a data.table of the PMIDs, with author counts, from Author-ity
source('scripts/pmids-authority.R')

# Extract the PMIDs shared by the PubMed dump and Author-ity
# that have the same numbers of authors associated with them
source('scripts/authority-pubmed-intersect.R')

# IN PROGRESS
# Construct networks from the literatures on several topics
source('scripts/topic-networks.R')
# Compute basic stats on these networks
source('scripts/topic-stats.R')



# Convert the `mh` field in the PubMed dump to codes from the tree (INCOMPLETE)
source('scripts/pubmed-mtrees.R')

# Construct and save a data.table of discipline sizes (INCOMPLETE)
source('scripts/discipline-sizes.R')
