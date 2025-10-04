import pandas as pd
import pymysql
from sqlalchemy import create_engine

conn = pymysql.connect(host="localhost", user="root", password="123456")
cur = conn.cursor()

cur.execute("CREATE DATABASE IF NOT EXISTS ecommerce_db")
conn.commit()
cur.close()
conn.close()

engine = create_engine("mysql+pymysql://root:123456@localhost:3306/ecommerce_db")

# 2. Load CSV bằng pandas
dimCustomer = pd.read_csv(r"E:\PowerBI\Ecommerce Consumer Behavior\dimCustomer.csv")
dimProduct = pd.read_csv(r"E:\PowerBI\Ecommerce Consumer Behavior\dimProduct.csv")
dimChannel = pd.read_csv(r"E:\PowerBI\Ecommerce Consumer Behavior\dimChannel.csv")
dimMarketing = pd.read_csv(r"E:\PowerBI\Ecommerce Consumer Behavior\dimMarketing.csv")
dimTime = pd.read_csv(r"E:\PowerBI\Ecommerce Consumer Behavior\dimTime.csv")
factSales = pd.read_csv(r"E:\PowerBI\Ecommerce Consumer Behavior\factSales.csv")

dimCustomer.to_sql("dimCustomer", engine, if_exists="replace", index=False)
dimProduct.to_sql("dimProduct", engine, if_exists="replace", index=False)
dimChannel.to_sql("dimChannel", engine, if_exists="replace", index=False)
dimMarketing.to_sql("dimMarketing", engine, if_exists="replace", index=False)
dimTime.to_sql("dimTime", engine, if_exists="replace", index=False)
factSales.to_sql("factSales", engine, if_exists="replace", index=False)

print("All CSV files have been loaded into MySQL!")