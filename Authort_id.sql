--- Write a SQL query to retrieve a list of authors who have viewed at least one of their own articles.


--- PySpark
from pyspark.sql import SparkSession
from pyspark.sql.functions import col

def etl(avow_sample):
    df= avow_sample.filter(col('author_id')==col('viewer_id'))
    df= df.select(col('author_id').alias('id')).distinct()
    return df.orderBy('id')

--- Python
import pandas as pd
import numpy as np

def etl(avow_sample):
    filtered_df = avow_sample[avow_sample["author_id"] == avow_sample["viewer_id"]]

    distinct_ids = filtered_df[["author_id"]].drop_duplicates().rename(columns={"author_id": "id"})

    result_df = distinct_ids.sort_values(by="id")

    return result_df

--- SQL
SELECT DISTINCT author_id AS id
FROM avow_sample
WHERE author_id = viewer_id
ORDER BY id ASC;

