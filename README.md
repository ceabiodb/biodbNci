# biodbNci

An R package for accessing biodbNci, a library for connecting to the National Cancer Institute (USA) CACTUS Database., based on R package/framework [biodb](https://github.com/pkrog/biodb/).

## Introduction

This package is an extension of [biodb](https://github.com/pkrog/biodb/) that implements a connector to biodbNci, a library for connecting to the National Cancer Institute (USA) CACTUS Database..

## Installation

Install the latest version of this package by running the following commands:
```r
devtools::install_github('pkrog/biodb', dependencies=TRUE)
devtools::install_github('pkrog/biodbNci', dependencies=TRUE)
```

## Examples

To instantiate a connector to biodbNci, a library for connecting to the National Cancer Institute (USA) CACTUS Database., run:
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

<!-- TODO -->
