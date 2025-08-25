---
You are working in the Food and Beverage industry, where product performance and stock availability must be tracked across sales and inventory systems.

You are provided with three datasets containing information about products, their sales, and stock levels.

For Python / PySpark / Scala, these are the DataFrames: products, sales, and inventory

For SQL / dbt, these are the table names: fnb_products, fnb_sales, and fnb_inventory

Your goal is to generate a summary report for each product that includes:

Total sales quantity

Total revenue

Total stock across all warehouses

Product name and category


--- SQL
-- Write query here
-- TABLE NAMES: `fnb_inventory`, `fnb_products`, `fnb_sales`
SELECT  p.product_id,
        p.name,
        p.category, 
        total_quantity,
        total_revenue,
        COALESCE(SUM(i.stock),0) AS total_stock
FROM (
    SELECT p.product_id,p.name,p.category,
             COALESCE(SUM(s.quantity),0) AS total_quantity,
             COALESCE(SUM(s.revenue),0) AS total_revenue
    FROM fnb_products p 
    LEFT JOIN fnb_sales s 
    ON p.product_id= s.product_id
    GROUP BY p.product_id, p.name, p.category
) p
LEFT JOIN fnb_inventory i ON i.product_id=p.product_id
GROUP BY p.product_id,p.name,p.category, total_quantity,total_revenue
ORDER BY p.category,p.product_id


--- DBT
-- Write query here
-- TABLE NAMES: `fnb_inventory`, `fnb_products`, `fnb_sales`
SELECT p.product_id, 
       p.name,
      p.category,
      total_quantity,
      total_revenue,
      COALESCE(SUM(i.stock),0) AS total_stock
FROM (
  SELECT p.product_id,
         p.name,
         p.category,
         COALESCE(SUM(s.quantity),0) AS total_quantity,
         COALESCE(SUM(s.revenue),0) AS total_revenue
  FROM {{ref("fnb_products")}} p
  LEFT JOIN {{ref('fnb_sales')}} s 
  ON p.product_id=s.product_id
  GROUP BY p.product_id,p.name,p.category
) p 
LEFT JOIN {{ref('fnb_inventory')}} i
ON p.product_id=i.product_id
GROUP BY p.product_id, p.name, p.category, total_quantity, total_revenue 
ORDER BY p.category,p.product_id

---Python
import pandas as pd
import numpy as np
import datetime
import json
import math
import re

def etl(inventory, products, sales):
    df= products.merge(sales, how='left',on='product_id')
    df=df.groupby(['product_id','name','category'],as_index=False).agg({'quantity':'sum','revenue':'sum'})
    df=df.merge(inventory, how='left',on='product_id')
    df=df.groupby(['product_id','name','category','quantity','revenue'],as_index=False).agg({'stock':'sum'})
    df.fillna(value=0,inplace=True)
    df.rename(columns={'quantity':'total_quantity','revenue':'total_revenue','stock':'total_stock'},inplace=True)
    return df[['product_id','name','category','total_quantity','total_revenue','total_stock']].sort_values(by=['category','product_id'])


--- PySpark
  
  


  


