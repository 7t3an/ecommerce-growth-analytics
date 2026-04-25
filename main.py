import pandas as pd
import os
from sqlalchemy import create_engine
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

if not DATABASE_URL:
    raise ValueError("DATABASE_URL not found in .env file")

engine = create_engine(DATABASE_URL)

def run_sql(file):
    with open(f"sql/{file}") as f:
        query = f.read()
    return pd.read_sql(query, engine)

data_quality_df = run_sql("data_quality.sql")

print(data_quality_df)