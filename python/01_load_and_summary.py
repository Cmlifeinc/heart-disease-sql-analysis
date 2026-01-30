import sqlite3
import pandas as pd

DB_PATH = "data/heart_disease.db"

def main() -> None:
    # Connect to SQLite database
    conn = sqlite3.connect(DB_PATH)
    df = pd.read_sql_query("SELECT * FROM heart_disease;", conn)
    conn.close()

    # Standardize column names (recommended)
    # Example: "Heart Disease" -> "heart_disease", "Max HR" -> "max_hr"
    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
    )

    # Basic info
    print("Total rows:", len(df))
    print("\nColumns:")
    print(df.columns.tolist())

    # Target distribution
    print("\nHeart Disease distribution:")
    print(df["heart_disease"].value_counts())

    # Group means by target
    print("\nAverage values by Heart Disease status:")
    means = (
        df.groupby("heart_disease")[["age", "bp", "cholesterol", "max_hr"]]
        .mean()
        .round(1)
    )
    print(means)

if __name__ == "__main__":
    main()
