# biodbNci

An R package for accessing biodbNci, a library for connecting to the National
Cancer Institute (USA) CACTUS API, based on R package/framework
[biodb](https://github.com/pkrog/biodb/).

## Introduction

This package is an extension of [biodb](https://github.com/pkrog/biodb/) that
implements a connector to biodbNci, a library for connecting to the National
Cancer Institute (USA) CACTUS Database.

## Installation

Install the latest version of this package by running the following commands:
```r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install('biodbNci')
```

## Examples

To instantiate a connector to NCI CACTUS, a library for connecting to the
National Cancer Institute (USA) CACTUS Database, run:
```r
mybiodb <- boidb::newInst()
conn <- mybiodb$getFactory()$createConn('nci.cactus')
mybiodb$terminate()
```

## Documentation

To get documentation on the implemented connector, run the following command in R:
```r
?biodbNci::NciCactusConn
```

## Citations

CADD Group Chemoinformatics Tools and User Services (CACTUS), National Cancer
Institute, at <https://cactus.nci.nih.gov/>.
