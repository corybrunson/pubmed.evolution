# Construct and run basic stats on the networks for each topic

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

# Read in the topic PMID vectors and the Author-ity PMID data.table
load('proj/pubmed.evolution/data/pmid-intersect.RData')
load('proj/pubmed.evolution/data/topic-pmids.RData')
load('proj/pubmed.evolution/data/hel-authority.RData')

# For each topic PMID vector `vec`...
for(i in 1:length(topic.pmids)) {
    vec <- topic.pmids[[i]]
    # Subset pmid.use on PMIDs in vec
    sub.use <- pmid.use[pmid %in% vec]
    # Create a vector of years with names the PMIDs
    yrs <- sub.use$year
    names(yrs) <- sub.use$pmid
    # Remove papers outside vec and then authors who have none inside vec
    sub.hel <- hel
    sub.hel$papers <- lapply(sub.hel$papers, intersect, y = vec)
    sub.hel <- subset(sub.hel, sapply(papers, length) > 0)
    # Create a bipartite graph from the hyper-edge list
    bigraph <- hel2bigraph(sub.hel)
    if(vcount(bigraph) == 0) next
    # Assign event nodes a `year` attribute
    V(bigraph)$year[which(V(bigraph)$type)] <-
        yrs[V(bigraph)$name[which(V(bigraph)$type)]]
    # Save the graph in a file
    save(bigraph, file = paste0('proj/pubmed.evolution/data/',
                                names(topic.pmids)[i], '-bigraph.RData'))
}

rm(list = ls())
