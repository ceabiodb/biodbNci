
# Set test context
biodb::testContext("Example long tests")

# Instantiate Biodb
biodb <- biodb::createBiodbTestInstance(ack=TRUE)

# Load package definitions
defFile <- system.file("definitions.yml", package='biodbNci')
biodb$loadDefinitions(defFile)

# Create connector
conn <- biodb$getFactory()$createConn('nci.cactus')

# Run tests
# TODO Implement your own tests

# Terminate Biodb
biodb$terminate()
