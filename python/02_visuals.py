import os
import sqlite3
import pandas as pd
import matplotlib.pyplot as plt

DB_PATH = "data/heart_disease.db"
OUT_DIR = "output"

def load_data() -> pd.DataFrame:
    conn = sqlite3.connect(DB_PATH)
    df = pd.read_sql_query("SELECT * FROM heart_disease;", conn)
    conn.close()

    # Standardize column names
    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
    )
    return df

def add_features(df: pd.DataFrame) -> pd.DataFrame:
    # Binary target for plotting
    df["is_presence"] = (df["heart_disease"] == "Presence").astype(int)

    # Age bands (same bins as SQL)
    def band(age: int) -> str:
        if age < 40:
            return "<40"
        if age <= 49:
            return "40-49"
        if age <= 59:
            return "50-59"
        if age <= 69:
            return "60-69"
        return "70+"

    df["age_band"] = df["age"].apply(band)
    return df

def plot_presence_rate_by_age_band(df: pd.DataFrame) -> str:
    order = ["<40", "40-49", "50-59", "60-69", "70+"]

    rates = (
        df.groupby("age_band")["is_presence"]
        .mean()
        .reindex(order)
        .mul(100)
    )

    plt.figure()
    rates.plot(kind="bar")
    plt.ylabel("Presence rate (%)")
    plt.title("Heart Disease Presence Rate by Age Band")
    plt.tight_layout()

    os.makedirs(OUT_DIR, exist_ok=True)
    out_path = os.path.join(OUT_DIR, "presence_rate_by_age_band.png")
    plt.savefig(out_path, dpi=200)
    plt.show()
    return out_path

def plot_presence_rate_by_sex(df: pd.DataFrame) -> str:
    rates = df.groupby("sex")["is_presence"].mean().mul(100)

    plt.figure()
    rates.plot(kind="bar")
    plt.ylabel("Presence rate (%)")
    plt.title("Heart Disease Presence Rate by Sex (Encoded)")
    plt.tight_layout()

    os.makedirs(OUT_DIR, exist_ok=True)
    out_path = os.path.join(OUT_DIR, "presence_rate_by_sex.png")
    plt.savefig(out_path, dpi=200)
    plt.show()
    return out_path

def main() -> None:
    df = add_features(load_data())

    age_path = plot_presence_rate_by_age_band(df)
    sex_path = plot_presence_rate_by_sex(df)

    print(f"Saved: {age_path}")
    print(f"Saved: {sex_path}")

if __name__ == "__main__":
    main()