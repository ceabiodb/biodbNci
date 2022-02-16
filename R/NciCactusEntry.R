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
#' mybiodb <- biodb::Biodb()
#'
#' # Get a connector that inherits from NciCactusConn:
#' conn <- mybiodb$getFactory()$createConn('nci.cactus')
#'
#' # Get the first entry
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
    ,

public=list(

initialize=function(...) {
    super$initialize(...)
}

,doCheckContent=function(content) {
    
    # You can do some more checks of the content here.
    
    return(TRUE)
}

,doParseFieldsStep2=function(parsed.content) {
    
    # TODO Implement your custom parsing processing here.
}
))
