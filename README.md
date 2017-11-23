# digIt
A simple R wrapper to dig into new example datasets for data science and statistics. This wrapper set simplifies access to data by loading datasets directly into memory from an AWS repository or downloads a zip file to the working directory.

## Dependencies
Wrapper relies on the `rio`, `DT`, and `rgdal` libraries.

## Usage

### `digList()`
Returns list of available datasets 

  ```r 
  digList(detail = FALSE)
  ```
- _Args_: 
  - detail = determines if description will be provided - renders in data tables format(default = FALSE)

- _Returns_:
  - List of example datasets

  
### `digIt()`
Retrieves example data, loads either to memory or downloads locally.

  ```r 
  digIt("stopwords")
  ```

- _Args_: 
  - dataset = string value containing name of dataset
  - download = downloads a .zip file of data and readme into working directory, otherwise, loads data into memory. (default = FALSE)
  - readme = prints readme (default = FALSE)
- _Returns_: 
  - dataset as a local download (download = TRUE) or in R environment (download = FALSE)
