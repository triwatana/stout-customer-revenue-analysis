"""Run the full analysis: run setup SQL, check data quality, execute metric queries,
and export each metric's results as CSV files to data/output/ for Tableau.
"""

import os
from pathlib import Path

import duckdb

ROOT = Path(__file__).resolve().parents[1] # root directory of project
SQL_DIR = ROOT / "sql" # folder containing SQL scripts
OUT_DIR = ROOT / "data" / "output" # folder where CSV results will be saved
DB_PATH = ROOT / "analysis.duckdb" # location of the DuckDB database


def split_statements(path: Path) -> list[str]:
    """Split a SQL file into statements, skipping comment-only chunks."""
    chunks = path.read_text(encoding="utf-8").split(";")
    statements = []
    for chunk in chunks:
        code_lines = [
            line for line in chunk.splitlines()
            if line.strip() and not line.strip().startswith("--")
        ]
        if code_lines:
            statements.append(chunk.strip())
    return statements

# Main function to run entire workflow
def main() -> None:
    os.chdir(ROOT)
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    con = duckdb.connect(str(DB_PATH))

    # Setup
    for stmt in split_statements(SQL_DIR / "00_setup.sql"):
        con.sql(stmt)
    print("Setup complete.\n")

    # Data quality checks
    print("=== Data quality checks ===")
    for stmt in split_statements(SQL_DIR / "00_data_quality.sql"):
        con.sql(stmt).show()

    # Metric queries
    metric_files = sorted(
        p for p in SQL_DIR.glob("[0-9][0-9]_*.sql") if not p.name.startswith("00")
    )
    for path in metric_files:
        result = None
        for stmt in split_statements(path): # Execute each SQL statement
            result = con.sql(stmt) # Stores result of the latest statement
        if result is None:
            continue
        df = result.df()
        df.to_csv(OUT_DIR / f"{path.stem}.csv", index=False)
        print(f"\n=== {path.stem} ===")
        print(df.to_string(index=False))

    con.close()


if __name__ == "__main__":
    main()