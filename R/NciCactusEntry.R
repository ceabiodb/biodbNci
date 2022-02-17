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
#' # Get the first entry
#' \donttest{ # Getting one entry requires the download of the whole database.
#' e <- conn$getEntry('749674')
#' }
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
