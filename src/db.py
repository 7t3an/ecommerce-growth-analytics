import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

engine = create_engine(DATABASE_URL)

def run_sql(file_path):
    with open(file_path) as f:
        query = f.read()
    return pd.read_sql(query, engine)