"""
pip install psycopg2
pip install sqlalchemy
"""

from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql://analista:segredo@localhost:5433/datawarehouse"

# Example connection string
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
session = Session()

# Example query
try:
#    conn = engine.connect()

    result = session.execute(text('SELECT * FROM vendas')).fetchall()
    print(result)

except Exception as e:
    print(f"An error occurred: {e}")
finally:
    print('finally')
    session.close()
