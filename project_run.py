import subprocess

# Step 1: Execute the Jupyter notebook
subprocess.run([
    "python",
    "-m",
    "jupyter",
    "nbconvert",
    "--to",
    "notebook",
    "--execute",
    "first_ETL_Project.ipynb",
    "--output",
    "first_ETL_Project.ipynb"
], check=True)

# Step 2: Run the SQL file through DuckDB
with open("data_transformation.sql", "r") as sql_file:
    sql = sql_file.read()

subprocess.run(
    ["duckdb", "exchange_rates.db"],
    input=sql,
    text=True,
    check=True
)

print("ETL pipeline completed successfully.")