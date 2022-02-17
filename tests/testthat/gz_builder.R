# Create output directory
outdir <- file.path(getwd(), 'output')
if ( ! dir.exists(outdir))
    dir.create(outdir)

# Build NCI CACTUS gz file
root <- system.file(package="biodbNci")
genfolder <- file.path(root, 'extdata', 'generated')
if ( ! dir.exists(genfolder))
    dir.create(genfolder, recursive=TRUE)
two_entries_gz_file <- file.path(genfolder, "cactus_extract.txt.gz")
if ( ! file.exists(two_entries_gz_file)) {

    # Get input file
    txtfile <- system.file('testref', 'cactus_two_full_entries.txt',
        package="biodbNci", mustWork=TRUE)
    testthat::expect_true(file.exists(txtfile))
    
    # Create gz file
    fd <- gzfile(two_entries_gz_file, 'w')
    writeLines(txtfile, fd)
    close(fd)
}
testthat::expect_true(file.exists(two_entries_gz_file))
