---
You are given a table named user_experiences that tracks the job history of various users, including the positions they held and the duration of each role.

Write a SQL query to compute the percentage of users who directly transitioned from the role of "Data Analyst" to "Data Scientist", without holding any intermediate positions between the two roles.

--- SQL
WITH CTE AS(
  SELECT user_id,
         position_name,
         start_date,
         end_date,
         ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY start_date ) AS rn 
  FROM cpt_user_experience
),
CTE2 AS(
  SELECT 
        c.user_id
  FROM CTE c
  JOIN CTE p 
  ON c.user_id= p.user_id AND c.rn= p.rn+1
  WHERE p.position_name='Data Analyst'
  AND   c.position_name='Data Scientist'
)
SELECT ROUND(COUNT(DISTINCT c.user_id) *100.0 / COUNT(DISTINCT cc.user_id),2) AS percentage
FROM cpt_user_experience cc
LEFT JOIN CTE2 c 
ON c.user_id=cc.user_id





--- PySpark
from pyspark.sql import functions as F
from pyspark.sql import Window as W
from pyspark.sql import SparkSession
import datetime
import json

spark = SparkSession.builder.appName('run-pyspark-code').getOrCreate()

def etl(input_df):
    # Step 1: Assign row number by user_id ordered by start_date
    window_spec = W.partitionBy("user_id").orderBy("start_date")
    
    ordered_df = input_df.select("user_id", "position_name", "start_date") \
        .withColumn("rn", F.row_number().over(window_spec))

    # Step 2: Self join to get consecutive roles
    prev_df = ordered_df.alias("prev")
    next_df = ordered_df.alias("next")
    
    transitions_df = prev_df.join(next_df, 
                                  (F.col("prev.user_id") == F.col("next.user_id")) & 
                                  (F.col("next.rn") == F.col("prev.rn") + 1)) \
        .filter((F.col("prev.position_name") == "Data Analyst") &
                (F.col("next.position_name") == "Data Scientist")) \
        .select(F.col("prev.user_id").alias("user_id")).distinct()

    # Step 3: Count matched and total users
    matched_count = transitions_df.select("user_id").distinct().count()
    total_count = input_df.select("user_id").distinct().count()
    
    # Step 4: Calculate percentage
    percentage = round((100.0 * matched_count / total_count), 2) if total_count > 0 else 0.0

    # Step 5: Return single-row DataFrame with the result
    return spark.createDataFrame([(percentage,)], ["percentage"])
