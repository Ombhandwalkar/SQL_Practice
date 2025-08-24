---A country is considered large if it meets at least one of the following criteria:

Its area is greater than or equal to 3,000,000 square kilometers.

Its population is greater than or equal to 25,000,000 people.

Your task is to write an SQL query to retrieve the name, population, and area of all such large countries.

--- SQL
-- Write query here
-- TABLE NAME: `bne_countries_val`
SELECT name, population, area
FROM bne_countries_val
WHERE area >=3000000 OR population >=25000000

--- Python
import pandas as pd
import numpy as np

def etl(bne_countries_val):
    return bne_countries_val[(bne_countries_val['area']>=3000000) | (bne_countries_val['population']>=25000000)][['name','population','area']]

--- PySpark
from pyspark.sql import SparkSession
from pyspark.sql.functions import col

def etl(bne_countries_val):
    df= bne_countries_val.filter((col('population')>=25000000) | (col('area')>=3000000))
    return df.select('name','population','area')