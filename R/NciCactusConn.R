#' biodbNci, a library for connecting to the National Cancer Institute (USA)
#' CACTUS Database. connector class.
#'
#' Connector class for biodbNci, a library for connecting to the National
#' Cancer Institute (USA) CACTUS Database.
#'
#' This class implements a connector for accessing the NCI database, using
#' CACTUS services.  See https://www.cancer.gov/ and
#' https://cactus.nci.nih.gov/.
#'
#' @seealso \code{\link{BiodbConn}}.
#'
#' @examples
#' # Create an instance with default settings:
#' mybiodb <- biodb::Biodb()
#'
#' # Get a connector:
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
NciCactusConn <- R6::R6Class("NciCactusConn",
inherit=biodb::BiodbConn,

public=list(

#' @description
#' New instance initializer. Connector classes must not be instantiated
#' directly. Instead, you must use the createConn() method of the factory class.
#' @param ... All parameters are passed to the super class initializer.
#' @return Nothing.
initialize=function(...) {
    super$initialize(...)
}

#' @description
#' Calls Chemical Identifier Resolver web service.
#' See https://cactus.nci.nih.gov/chemical/structure_documentation for details.
#' @param structid The submitted structure identifier.
#' @param repr The wanted representation.
#' @param xml A flag for choosing the format returned by the web service
#' between plain text and XML.
#' @param retfmt Use to set the format of the returned value. 'plain' will
#' return the raw results from the server, as a character value. 'parsed' will
#' return the parsed results, as an XML object. 'request' will return a
#' BiodbRequest object representing the request as it would have been sent.
#' 'ids' will return a character vector containing the IDs of the matching
#' entries.
#' @return Depending on `retfmt` parameter.
,wsChemicalIdentifierResolver=function(structid, repr, xml=FALSE,
    retfmt=c('plain', 'parsed', 'ids', 'request')) {

    retfmt <- match.arg(retfmt)
    
    # Build request
    url <- c(self$getPropValSlot('urls', 'ws.url'), 'chemical', 'structure',
             structid, repr)
    if (xml)
        url <- c(url, 'xml')
    request <- self$makeRequest(method='get', url=BiodbUrl$new(url=url))
    if (retfmt == 'request')
        return(request)

    # Send request
    results <- self$getBiodb()$getRequestScheduler()$sendRequest(request)

    # Parse
    if (retfmt != 'plain' && xml) {

        # Parse XML
        results <-  XML::xmlInternalTreeParse(results, asText=TRUE)

        if (retfmt == 'ids') {
            results <- XML::xpathSApply(results, "//item", XML::xmlValue)
            if (is.list(results)
                && all(vapply(results, is.null, FUN.VALUE=TRUE)))
                results <- character()
        }
    }

    return(results)
}

#' @description
#' Calls wsChemicalIdentifierResolver() to convert a list of IDs into
#' another representation.
#' @param ids A character vector containing IDs.
#' @param repr The targeted representation.
#' @return A character vector, the same length as `ids`, containing
#' the converted IDs. NA values will be set when conversion is not possible.
,conv=function(ids, repr) {
    
    res <- character()
    msg <- paste0('Converting IDs to ', repr)
    
    # Loop on all IDs
    prg <- biodb::Progress$new(biodb=self$getBiodb(), msg=msg,
        total=length(ids))
    for (id in ids) {
        r <- self$wsChemicalIdentifierResolver(structid=id, repr=repr,
            xml=TRUE, retfmt='ids')
        if (length(r) == 0)
            r <- NA_character_
        
        res <- c(res, r)
        
        # Send progress message
        prg$increment()
    }
    
    return(res)
}

#' @description
#' Converts a list of CAS IDs into a list of InChI.
#' @param cas A character vector containing CAS IDs.
#' @return A character vector, the same length as `ids`, containing InChI
#' values or NA values where conversion was not possible.
,convCasToInchi=function(cas) {
return(self$conv(cas, 'InChI'))
}

#' @description
#' Converts a list of CAS IDs into a list of InChI keys.
#' @param cas A character vector containing CAS IDs.
#' @return A character vector, the same length as `ids`, containing InChI Key
#' values or NA values where conversion was not possible.
,convCasToInchikey=function(cas) {
    
    inchikey <- self$conv(cas, 'InChIKEY')
    inchikey <- sub('^InChIKey=', '', inchikey)
                    
    return(inchikey)
}

),

private=list(

doGetEntryContentFromDb=function(id) {

    # Initialize return values
    content <- rep(NA_character_, length(id))

    # TODO Implement retrieval of entry contents.

    # Some debug message
    if (length(content) > 0)
        biodb::logDebug0("Content of first entry: ", content[[1]])

    return(content)
}

,doGetEntryIds=function(max.results=NA_integer_) {
    # Overrides super class' method.

    ids <- NA_character_
 
    # Download
    self$download()

    # Get IDs from cache
    cch <- self$getBiodb()$getPersistentCache()
    ids <- cch$listFiles(self$getCacheId(),
                         ext=self$getPropertyValue('entry.content.type'),
                         extract.name=TRUE)
    
    return(ids)
}

,doSearchForEntries=function(fields=NULL, max.results=NA_integer_) {
    # Overrides super class' method.

    ids <- character()

    # TODO Implement search of entries by filtering on values of fields.
    
    return(ids)
}

,doGetEntryContentRequest=function(id, concatenate=TRUE) {

    # TODO Modify the code below to build the URLs to get the contents of the
    # entries.
    # Depending on the database, you may have to build one URL for each
    # individual entry or may be able to write just one or a few URL for all
    # entries to retrieve.
    u <- c(self$getPropValSlot('urls', 'base.url'), 'entries',
           paste(id, 'xml', sep='.'))
    url <- BiodbUrl$new(url=u)$toString()

    return(url)
}

,doGetEntryPageUrl=function(id) {
    return(rep(NA_character_, length(id)))
}

,doGetEntryImageUrl=function(id) {
    return(rep(NA_character_, length(id)))
}

,doDownload=function() {

    # Build the URL to the file to download
    u <- self$getPropValSlot('urls', 'db.gz.url')
    biodb::logInfo('Downloading NCI CACTUS database at "%s" ...', u)
    cch <- self$getBiodb()$getPersistentCache()
    
    # Real URL
    if (grepl('^([a-zA-Z]+://)', u)) {
        ext <- self$getPropertyValue('dwnld.ext')
        tmpFile <- tempfile("nci.cactus", tmpdir=cch$getTmpFolderPath(),
            fileext=ext)
        gz.url <- BiodbUrl$new(url=u)
        sched <- self$getBiodb()$getRequestScheduler()
        sched$downloadFile(url=gz.url, dest.file=tmpFile)
        self$setDownloadedFile(tmpFile, action='move')
        
    # Path to local file
    } else {
        if ( ! file.exists(u))
            biodb::error("Source file %s does not exist.", u)
        self$setDownloadedFile(u, action='copy')
    }
}

,doExtractDownload=function() {

    biodb::logInfo0("Extracting content of downloaded biodbNci, a library for ",
        "connecting to the National Cancer Institute (USA) CACTUS Database....")
    cch <- self$getBiodb()$getPersistentCache()
 
    # Expand compressed file
    extract.dir <- cch$getTmpFolderPath()
    txtfile <- file.path(extract.dir, "cactus_rdfs")
    fd <- gzfile(self$getDownloadPath(), 'r')
    writeLines(readLines(fd), txtfile) # TODO To improve, takes more than 60min.
    close(fd)
 
    # Delete existing cache files
    biodb::logDebug('Delete existing entry files in cache system.')
    ect <- self$getPropertyValue('entry.content.type')
    cch$deleteFiles(self$getCacheId(), ext=ect)

    # Extract entries
    biodb::logDebug0('Extract single entries from downloaded file "', txtfile,
        '", into "', extract.dir, '".')
    entryFiles <- extractEntries(normalizePath(txtfile),
        normalizePath(extract.dir))

    # Move extracted files into cache
    cch$moveFilesIntoCache(unname(entryFiles), cache.id=self$getCacheId(),
        name=names(entryFiles), ext=ect)

    # Remove extracted XML database file
    biodb::logDebug('Delete extracted database.')
    unlink(txtfile)
}
))
