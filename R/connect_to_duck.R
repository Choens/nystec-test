connect_to_duck <- function() {
    return(
      DBI::dbConnect(duckdb::duckdb(), dbdir="./data/claims.duckdb")
    )
}