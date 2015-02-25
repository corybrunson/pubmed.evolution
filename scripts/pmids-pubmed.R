# Create a table of PMIDs and numbers of authors from PubMed

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
pubmed.files <- paste0(
    'data/medline/',
    list.files('data/medline/', 'medline12n*')
)

# http://stackoverflow.com/questions/4806823/
# how-to-detect-the-right-encoding-for-read-csv

dat2pmid <- function(dat) {
    data.table(
        pmid = as.numeric(as.character(dat$pmid)),
        count = count.instances(as.character(dat$au), '|') + 1,
        year = as.numeric(substr(dat$dp, 1, 4))
    )
}

# REMOVED OR REPLACED STRAY UNPAIRED DOUBLE-QUOTES:
# medline12n0187.xml.txt: 17955638
# medline12n0280.xml.txt: 3239894
# medline12n0305.xml.txt: 2276911, 1703876
# medline12n0307.xml.txt: 2135042
# medline12n0315.xml.txt: 1833736
# medline12n0325.xml.txt: 1608973
# medline12n0338.xml.txt: 8497852
# medline12n0367.xml.txt: 7656565
# medline12n0375.xml.txt: 8927641
# medline12n0376.xml.txt: 8631510, 8614491
# medline12n.xml.txt: 8631510

# medline12n0446.xml.txt: 11053342 R"R-01243 -> RR-01243

# PMIDs!
pmid.dt2 <- c()
j <- 0
for(file in pubmed.files) {
    print(file)
    lines <- readLines(file)
    new.dat <- read.pubmed(file)
    if(nrow(new.dat) != length(lines) - 1) stop('Bad read')
    new.pmid <- cbind(dat2pmid(new.dat), file = as.numeric(substr(file, 24, 27)))
    # Append to existing data and save
    pmid.dt2 <- rbindlist(list(pmid.dt2, new.pmid))
    if(grepl('000', file))
        save(pmid.dt2, file = 'proj/pubmed.evolution/data/pmids-pubmed.RData')
}

# sort by PMID
setkey(pmid.dt2, pmid)
save(pmid.dt2, file = 'proj/pubmed.evolution/data/pmids-pubmed.RData')

rm(list = ls())
