# Create a data.table of author IDs with a list column of PMIDs

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
cols <- strsplit(readLines(con, n = 1), ',')[[1]]
close(con)
dats <- list() # hyper-edge lists
i <- 1
while(i < no.aid) {
    nrows <- min(no.lines, no.aid - i)
    # read as a data.table
    new.dat <- fread(authority, header = FALSE,
                     sep = ',',
                     skip = i, nrows = no.lines)
    setnames(new.dat, colnames(new.dat), cols)
    new.dat <- new.dat[, c('author', 'papers'), with = FALSE]
    dats <- c(dats, list(new.dat))
    i <- i + nrows
    print(i)
}

# combine hyper-edge lists
hel <- rbindlist(dats)
# remove author placement indicators
hel[, papers := gsub('([0-9])\\_[0-9]+((?:$|\\|))', '\\1\\2', papers)]
# split papers column at pipes
hel[, papers := strsplit(papers, '\\|')]

save(hel, file = 'proj/pubmed.evolution/data/hel-authority.RData')

rm(list = ls())
