# Create a table of PMIDs and numbers of authors from Author-ity

# set working directory
if(file.exists('~/Documents')) setwd('~/Documents/CQM/')
setwd('PubMed/')
# load packages
pkgs <- c('pubmed.network', 'snow', 'parallel')
for(pkg in pkgs) {
    if(!require(pkg, character.only = TRUE)) {
        install.packages(pkg)
        stopifnot(require(pkg, character.only = TRUE))
    }
}

# source code
source('proj/pubmed.evolution/code/medline2R.R')

# how many lines to read at a time
no.lines <- 10000

# names of common data sources
authority <- 'data/authority/authority.csv'

# vector of papers column of authority.csv
no.aid <- countLines(authority)[[1]] - 1
# http://stackoverflow.com/questions/7156770/
# in-r-how-can-read-lines-by-number-from-a-large-file
con <- file(authority)
open(con)
header <- readLines(con, n = 1)
pmid.col <- c()
i <- 1
while(i < no.aid) {
    nrows <- min(no.lines, no.aid - i)
    new.lines <- readLines(con, n = nrows)
    new.tab <- read.csv(textConnection(new.lines, 'rt'), header = FALSE)
    pmid.col <- c(pmid.col, as.character(new.tab[, 6]))
    i <- i + nrows
    print(i)
}
close(con)

save(pmid.col, file = 'proj/pubmed.evolution/data/pmids-authority.RData')

# split by '|', unlist, and remove author position indicators
pmid.vec <- gsub('_[0-9]+$', '', unlist(strsplit(pmid.col, '|', fixed = TRUE)))

# make a frequency table and sort it by PMID
pmid.tab <- table(pmid.vec)
pmid.dt1 <- data.table(pmid = as.numeric(names(pmid.tab)), count = pmid.tab)

setkey(pmid.dt1, pmid)
save(pmid.dt1, file = 'proj/pubmed.evolution/data/pmids-authority.RData')

rm(list = ls())
