EMPTY <- system.file('testref', 'cactus_empty.txt', package='biodbNci')
SINGLE_ENTRY <- system.file('testref', 'cactus_one_entry.txt',
    package='biodbNci')
TWO_ENTRIES <- system.file('testref', 'cactus_two_entries.txt',
    package='biodbNci')
NO_ID <- system.file('testref', 'cactus_single_entry_no_id.txt',
    package='biodbNci')
WRONG_ID_TAG <- system.file('testref', 'cactus_single_entry_wrong_id.txt',
    package='biodbNci')
DST_DIR <- file.path(getwd(), 'output', 'extract_dir')

test_extractEntries <- function() {

    # Test bad file
    testthat::expect_error(extractEntries("", ""))
    testthat::expect_error(extractEntries("some_non_existing_file", ""))

    # Test bad output dir
    testthat::expect_error(extractEntries(SINGLE_ENTRY,
        "some_non_existing_dir"))

    # Test empty XML file
    unlink(DST_DIR, recursive=TRUE)
    dir.create(DST_DIR, recursive=TRUE)
    extractEntries(EMPTY, DST_DIR)
    testthat::expect_length(Sys.glob(file.path(DST_DIR, '*')), 0)

    # Test file with single entry, no ID
    testthat::expect_error(extractntries(NO_ID, DST_DIR))

    # Test file with single entry, wrong ID tag
    testthat::expect_error(extractEntries(WRONG_ID_TAG, DST_DIR))

    # Test file with single entry
    unlink(DST_DIR, recursive=TRUE)
    dir.create(DST_DIR, recursive=TRUE)
    files <- extractEntries(SINGLE_ENTRY, DST_DIR)
    testthat::expect_length(files, 1)
    testthat::expect_equal(names(files), '1')
    found_files <- Sys.glob(file.path(DST_DIR, '*'))
    testthat::expect_identical(unname(files), found_files)
    testthat::expect_true(all(vapply(found_files,
        function(f) file.info(f)$size, FUN.VALUE=1) > 0))

    # Test file with two entries
    unlink(DST_DIR, recursive=TRUE)
    dir.create(DST_DIR, recursive=TRUE)
    files <- extractEntries(TWO_ENTRIES, DST_DIR)
    testthat::expect_length(files, 2)
    testthat::expect_equal(names(files), c('1', '1234'))
    found_files <- Sys.glob(file.path(DST_DIR, '*'))
    testthat::expect_identical(unname(files), found_files)
    testthat::expect_true(all(vapply(found_files,
        function(f) file.info(f)$size, FUN.VALUE=1) > 0))
}

# Set test context
biodb::testContext("Tests of independent functions")

# Run tests
biodb::testThat("extractEntries() works fine.", test_extractEntries)
