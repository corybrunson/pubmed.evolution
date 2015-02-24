# Set locale to prevent grep errors
# http://stackoverflow.com/questions/3548090/
# facet-grid-problem-input-string-1-is-invalid-in-this-locale
#Sys.setlocale(locale = 'C')

# File name, with fixed-length numerical identifier
medline.files <- function(vec) {
    sprintf('medline/data/medline12n%04d.xml.txt', vec)
}

# Read data for the given range of years from one file
# with the option of also matching ANY of the strings in keys
read.medline.once <- function(i = NULL, file = medline.files(i),
                              start = 1800, finish = 3000,
                              keys = c(), no.lines, N = 1000) {
    if(file.exists(file)) f <- file(file, 'rt') else return(c())
    greped <- c()
    # Collect lines in which a year from the range appears,
    # in batches of size N
    repeat {
        lines = readLines(f, n = N)
        incl <- unique(unlist(lapply(start:finish, grep, x = lines)))
        incl <- intersect(incl, grep(paste(keys, collapse = '|'), x = lines,
                                     ignore.case = TRUE))
        greped <- c(greped, lines[incl])
        if(N != length(lines)) break
    }
    close(f)
    if(length(greped) == 0) return(c())
    # Store the relevant lines as a connection
    tc <- textConnection(greped, 'rt')
    # Read the connection into a data frame
    df <- read.csv(tc, header = TRUE,
                   colClasses = c(rep('character', 3),
                                  rep('factor', 2),
                                  rep('character', 2),
                                  'factor',
                                  'character',
                                  'factor',
                                  rep('character', 4),
                                  'factor'))
    names(df) <- names(read.csv(file = file, nrows = 1))
    # Remove accidental matches by restricting the match to the dp field
    df <- df[unique(unlist(lapply(start:finish, grep, x = df$dp))), ]
    return(df)
}
# Read data for the given range of years from the given range of files
# Keys, if left blank, incorporates all the specifications, in order,
# into the first screen
# (Leave keys blank unless fiddling around)
read.medline <- function(vec = 0000:9999, start = 1800, finish = 3000,
                         au = '', jid = '', pt = '', mh = '', co = '',
                         keys = paste(c(paste(au, collapse = '|'),
                                        paste(jid, collapse = '|'),
                                        paste(pt, collapse = '|'),
                                        paste(mh, collapse = '|'),
                                        paste(co, collapse = '|')),
                                      collapse = '.*'), ...) {
    df <- do.call(rbind, lapply(vec, read.medline.once, ...,
                                start = start, finish = finish, keys = keys))
    df <- df[grep(au, paste(df$fau, df$au), ignore.case = TRUE), ]
    df <- df[grep(jid, df$jid, ignore.case = TRUE), ]
    df <- df[grep(pt, df$pt, ignore.case = TRUE), ]
    if(!is.null(mh)) df <- df[grep(mh, df$mh, ignore.case = TRUE), ]
    df <- df[grep(co, df$co, ignore.case = TRUE), ]
}
