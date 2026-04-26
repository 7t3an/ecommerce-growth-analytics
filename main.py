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

product_df = run_sql("product_mart.sql")

print(product_df.head())