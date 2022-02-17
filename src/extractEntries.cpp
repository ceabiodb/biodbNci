/* vi: se fdm=marker ts=4 et cc=80: */

#include <Rcpp.h>
#include <fstream>
#include <sys/stat.h>

//' Extract entries from NCI CACTUS .
//'
// ' The input file is read entirely and each entry (separated by '$$$$' line)
// is extracted and written in a separate file inside the destination
// folder.
// '
// ' @param file Path of the NCI CACTUS database file.
// ' @param extractDir Path of the folder where to extract entries.
// ' @return A character vector containing the paths to the extracted entries.
// ' Names are set to the entry accessions.
// '
// ' @export
// [[Rcpp::export]]
Rcpp::StringVector extractEntries(const std::string& file,
    const std::string& extractDir) {

    Rcpp::StringVector entryFiles;

    // Check destination folder exists
    struct stat info;
    if (stat(extractDir.c_str(), &info) != 0 || ! (info.st_mode & S_IFDIR))
        Rcpp::stop("Destination folder \"%s\" does not exist.", extractDir.c_str());

    // Open file
    std::ifstream inf(file.c_str());

    // Check file exists
    if ( ! inf.good())
        Rcpp::stop("File does not exist.");

    // Read input file line by line
    int file_index = 0;
    std::string entry_filename;
    std::string entry_id;
    std::vector<std::string> entry_ids;
    std::ofstream *outf = NULL;
    std::string line;
    while (std::getline(inf, line)) {

        // Write to file
        if ( ! outf) {
            std::ostringstream filename;
            filename << extractDir << "/entry_" << ++file_index << ".txt";
            entry_filename = filename.str();
            outf = new std::ofstream(entry_filename.c_str());
        }
        *outf << line << "\n";
        
        // Read ID
        if (entry_id.empty()) {

            entry_id = line;
            
            // Check
            for (char const &c: entry_id)
                if (c < '0' || c > '9')
                    Rcpp::stop("Wrong format for entry ID.");
        }

        // Close file
        if (line == "$$$$") {
            entryFiles.push_back(entry_filename);
            entry_ids.push_back(entry_id);
            outf->close();
            outf = NULL;
            entry_id = "";
            entry_filename = "";
        }
    }

    // Close file
    inf.close();

    // Set names of vector elements to entry IDs
    entryFiles.attr("names") = entry_ids;

    return entryFiles;

}
