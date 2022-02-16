# biodbNci

An R package for accessing biodbNci, a library for connecting to the National
Cancer Institute (USA) CACTUS Database, based on R package/framework
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
BiocManager::install('biodb')
devtools::install_github('pkrog/biodbNci', dependencies=TRUE)
```

## Examples

To instantiate a connector to NCI CACTUS, a library for connecting to the
National Cancer Institute (USA) CACTUS Database, run:
```r
mybiodb <- biodb::Biodb()
conn <- mybiodb$getFactory()$createConn('nci.cactus')
mybiodb$terminate()
```

## Documentation

To get documentation on the implemented connector, run the following command in R:
```r
?biodbNci::NciCactusConn
```

## Citations

CADD Group Chemoinformatics Tools and User Services, National Cancer Institute,
at <https://cactus.nci.nih.gov/>.
