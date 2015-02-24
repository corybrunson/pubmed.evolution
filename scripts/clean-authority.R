## Construct a large flat file for the following Author-ity fields:
# 4. Author-ity ID (AID) of author
# 5. number of author instances
# 12. range of years
# 15. names of journals (count)
# 18. AIDs of co-authors (count)
# 19. PMIDs of author instances
# 20. grant IDs
# 21. total citations
# 23. PMIDs by the author that have been cited (count)
# 24. PMIDs that the author cited (count)
# 25. PMIDs that cited the author (count)

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

# authority file names
authority.files <- paste0('data/authority/',
                          list.files('data/authority/', 'authority2009.part*'))

# which fields to include
wh.col <- c(4:5, 12, 15, 18:21, 23:25)
col.names <- c(
    'author', 'no.papers', 'years', 'journals', 'coauthors', 'papers', 'grants'
    , 'citations', 'no.citations', 'cited', 'cited.by'
)
stopifnot(length(wh.col) == length(col.names))

# how many lines to read at a time
no.lines <- 10000

# initialize empty file
new.file <- 'data/authority/authority.csv'
write(col.names, file = new.file, ncolumns = length(col.names),
      append = FALSE, sep = ',')

# for each authority file, in batches of no.lines:
for(f in authority.files) {
    n <- 0
    N <- countLines(f)
    con <- file(f)
    open(con)
    while(N > n) {
        lines <- readLines(con, n = no.lines)
        n <- n + length(lines)
        mat <- do.call(rbind, subsplit(lines, '\t', inds = wh.col))
        write.table(as.data.frame(mat), file = new.file, append = TRUE,
                    quote = TRUE, sep = ',',
                    row.names = FALSE, col.names = FALSE)
        print(n)
    }
    close(con)
}

rm(list = ls())
