---
A group of passengers is waiting in line to board a bus. However, the bus has a maximum weight capacity of 1000 kilograms. Passengers board one at a time based on their boarding order, and the boarding process stops as soon as the next passenger would cause the total weight to exceed the limit.


-- Python 
import pandas as pd
import numpy as np
import datetime
import json
import math
import re

def etl(mcb_sample):
	 mcb_sample['cumulative_sum']= mcb_sample['weight_kg'].cumsum().sort_values(by='passenger_id')
   return mcb_sample[mcb_sample['cumulative_sum'] <=1000][['passenger_id']].sort_values(by='cumulative_sum')


--- SQL

WITH CTE AS (
  SELECT *, SUM(weight_kg) OVER(ORDER BY boarding_order) AS cumulative_sum
  FROM mcb_sample
)
SELECT passenger_name
FROM CTE 
WHERE cumulative_sum <= 1000
ORDER BY cumulative_sum DESC 
LIMIT 1

--- PySpark
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum as spark_sum
from pyspark.sql.window import Window as W

def etl(mcb_sample):
    #write your code here
    window_s= W.orderBy('boarding_order').rowsBetween(W.unboundedPreceding, W.currentRow)
    df= mcb_sample.withColumn('total_weight', F.sum('weight_kg').over(window_s))
    valid_pass= df.filter(col('total_weight')<=1000)
    df= df.orderBy(col('total_weight').desc()).limit(1)
    return df.select('passenger_name')


  