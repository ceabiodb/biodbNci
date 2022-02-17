test.nci.cactus.wsChemicalIdentifierResolver <- function(conn) {

    # Plain
    res <- conn$wsChemicalIdentifierResolver(structid='557795-19-4',
                                             repr='InChIKEY')
    testthat::expect_is(res, 'character')
    testthat::expect_equal(res, 'InChIKey=WINHZLLDWRZWRT-IUQVRHKZNA-N')

    # XML parsed
    res <- conn$wsChemicalIdentifierResolver(structid='557795-19-4',
                                             repr='InChIKEY', xml=TRUE,
                                             retfmt='parsed')
    testthat::expect_is(res, 'XMLInternalDocument')

    # XML parsed and IDs returned
    res <- conn$wsChemicalIdentifierResolver(structid='557795-19-4',
                                             repr='InChIKEY', xml=TRUE,
                                             retfmt='ids')
    testthat::expect_is(res, 'character')
    testthat::expect_equal(res, 'InChIKey=WINHZLLDWRZWRT-IUQVRHKZNA-N')

    # SMILES to InChI
    res <- conn$wsChemicalIdentifierResolver(structid='C=O',
                                             repr='InChI')
    testthat::expect_is(res, 'character')
    testthat::expect_equal(res, 'InChI=1/CH2O/c1-2/h1H2')
}

# Set test context
biodb::testContext("Tests of web services")

source('gz_builder.R')

# Instantiate Biodb
biodb <- biodb::createBiodbTestInstance(ack=TRUE)

# Load package definitions
defFile <- system.file("definitions.yml", package='biodbNci')
biodb$loadDefinitions(defFile)

# Create connector
conn <- biodb$getFactory()$createConn('nci.cactus')
conn$setPropValSlot('urls', 'db.gz.url', two_entries_gz_file)

# Run tests
biodb::testThat('Web service wsChemicalIdentifierResolver works fine.',
          test.nci.cactus.wsChemicalIdentifierResolver, conn=conn)

# Terminate Biodb
biodb$terminate()
