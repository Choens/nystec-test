all: data/claims.duckdb report.docx

# Create the data set.
data/claims.duckdb: data/claims.R data/Research_Question_1.xls
	Rscript data/claims.R

# Run the report.
report.docx: report.qmd data/claims.R data/claims.duckdb