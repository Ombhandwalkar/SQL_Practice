---
Your task is to write a function or SQL query that returns the top 3 selling products in each product category, ranked by revenue (highest first).

--- SQL
SELECT p.category, p.product_name, DENSE_RANK() OVER( PARTITION BY p.category ORDER BY m.revenue DESC) AS rank , m.revenue
FROM manufacture_product p
JOIN manufacture_sales m 
ON p.product_id=m.product_id

--- DBT
SELECT p.category, p.product_name, DENSE_RANK() OVER( PARTITION BY p.category ORDER BY m.revenue DESC) AS rank , m.revenue
FROM {{ref("manufacture_product")}} p
JOIN {{ref("manufacture_sales")}} m 
ON p.product_id=m.product_id

--- Python
import pandas as pd

def etl(products, sales):
    sales_agg = sales.groupby("product_id")["revenue"].sum().reset_index()

    products_with_revenue = products.merge(sales_agg, on="product_id", how="inner")

    products_with_revenue["rank"] = products_with_revenue.groupby("category")["revenue"].rank(method="dense", ascending=False).astype(int)
    
    top_products = products_with_revenue[products_with_revenue["rank"] <= 3]

    result = top_products[["category", "product_name", "rank", "revenue"]]

    result["revenue"] = result["revenue"].astype(int)

    result = result.sort_values(["category", "rank"])
    
    return result

--- PySpark
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql import Window as W
import pyspark
import datetime
import json

spark = SparkSession.builder.appName('run-pyspark-code').getOrCreate()

def etl(products, sales):
  saless= sales.groupBy('product_id').agg(F.sum('revenue').alias('revenue'))
  df= products.join(saless, on='product_id',how='inner')
  wd= W.partitionBy('category').orderBy(F.desc('revenue'))
  df= df.select('category','product_name',F.dense_rank().over(wd).alias('rank'),'revenue')
  df= df.filter(F.col('rank')<=3)
  return df
