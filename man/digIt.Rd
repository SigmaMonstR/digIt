\name{digIt}
\alias{digIt}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Simple tools to access new data sets for data science
}
\description{
Most example datasets available for statistics and data science are overly simplified. This wrapper provides access to a curated set of more complex data.

}
\usage{
digIt(dataset, download = FALSE, readme = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{dataset}{
%%     ~~Describe \code{dataset} here~~
}
  \item{download}{
%%     ~~Describe \code{download} here~~
}
  \item{readme}{
%%     ~~Describe \code{readme} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (dataset, download = FALSE, readme = FALSE) 
{
    base.path <- "https://s3.amazonaws.com/whoa-data/"
    index.pos <- grep(dataset, digit.cache$dataset)[1] * 1
    if (length(index.pos) == 0) {
        warning("Dataset not found. Look up datasets using digList()")
    }
    else {
        download.zip <- paste0(base.path, digit.cache$zip.package[index.pos])
        download.data <- paste0(base.path, digit.cache$file.name[index.pos])
        download.readme <- paste0(base.path, digit.cache$readme[index.pos])
        load.function <- digit.cache$func[index.pos]
    }
    if (download == TRUE && length(index.pos) > 0) {
        download.file(download.zip, getwd())
        message(paste0(dataset, " has been downloaded to ", getwd()))
    }
    else if (download == FALSE && length(index.pos) > 0) {
        if (load.function == "import") {
            df <- import(download.data)
            message(paste0(dataset, " has been loaded into memory."))
            message(paste0("Dimensions: n = ", nrow(df), ", k = ", 
                ncol(df)))
            if (readme == TRUE) {
                temp.file <- tempfile()
                download.file(download.readme, temp.file, quiet = TRUE)
                file.show(temp.file)
            }
            return(df)
        }
        else if (load.function == "shp" && length(index.pos) > 
            0) {
            if (readme == TRUE) {
                temp.file <- tempfile()
                download.file(download.readme, temp.file, quiet = TRUE)
                file.show(temp.file)
            }
            temp.file <- tempfile()
            download.file(download.zip, temp.file, quiet = TRUE)
            temp.dir <- tempdir()
            unzip(temp.file, exdir = temp.dir)
            shape <- readOGR(dsn = temp.dir, layer = "cb_2016_us_cd115_20m")
            message(paste0(dataset, " has been loaded into memory."))
            return(shape)
        }
    }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
