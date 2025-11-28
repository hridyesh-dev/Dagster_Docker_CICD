
from pathlib import Path
import pandas as pd
from dagster import asset

PROJECT_ROOT = Path(__file__).resolve().parents[2]  # points to project root
DATA_DIR = Path.cwd() / "data"

@asset
def raw_data():
    csv_path = DATA_DIR / "data.csv"
    df = pd.read_csv(csv_path, on_bad_lines="skip", header=None, names=["name", "age"])
    return df

@asset
def cleaned_data(raw_data):
    return raw_data.dropna()

@asset
def stored_data(cleaned_data):
    out_path = DATA_DIR / "cleaned_output.csv"
    cleaned_data.to_csv(out_path, index=False)
    return str(out_path)

@asset
def validate(stored_data):
    df = pd.read_csv(stored_data)
    row_count = len(df)
    print("Row count:", row_count)
    return row_count
