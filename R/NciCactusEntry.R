#' biodbNci, a library for connecting to the National Cancer Institute (USA)
#' CACTUS Database. entry class.
#'
#' Entry class for biodbNci, a library for connecting to the National Cancer
#' Institute (USA) CACTUS Database.
#'
#' @seealso
#' \code{\link{BiodbSdfEntry}}.
#'
#' @examples
#' # Create an instance with default settings:
#' mybiodb <- biodb::newInst()
#'
#' # Get a connector that inherits from NciCactusConn:
#' conn <- mybiodb$getFactory()$createConn('nci.cactus')
#'
#'
#' # Use a database extract in order to avoid the downloading of the whole
#' # database.
#' dbExtract <- system.file("extdata", 'generated', "cactus_extract.txt.gz",
#'     package="biodbNci")
#' conn$setPropValSlot('urls', 'db.gz.url', dbExtract)
#'
#' # Get an entry
#' e <- conn$getEntry('749674')
#'
#' # Terminate instance.
#' mybiodb$terminate()
#'
#' @import biodb
#' @import R6
#' @export
NciCactusEntry <- R6::R6Class("NciCactusEntry",
    inherit=
        biodb::BiodbSdfEntry
)
