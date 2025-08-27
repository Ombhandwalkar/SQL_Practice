---
You are given three tables containing information about films, viewers, and their respective ratings. Your task is to:

Identify the viewer who has rated the most number of films.

If multiple viewers have the same highest number of ratings, return the viewer whose name is lexicographically smallest.

Identify the film with the highest average rating in February 2020.

If multiple films share the same highest average rating, return the one with the lexicographically smallest title.

--- SQL
-- Write query here
-- TABLE NAME: `trb_viewers` and `trb_films_ratings` and `trb_films` 
WITH CTE AS (
  SELECT v.full_name AS results,
  COUNT(fr.film_id) AS max_rating
  FROM trb_viewers v 
  JOIN trb_film_ratings fr 
  ON v.viewer_id=fr.viewer_id
  GROUP BY v.full_name
  ORDER BY max_rating  DESC, results ASC 
  LIMIT 1
),
CTE2 AS (
  SELECT 
  tf.title AS results,
  AVG(fr.rating) AS max_rating
  FROM trb_films tf 
  JOIN trb_film_ratings fr 
  ON tf.film_id=fr.film_id
  WHERE fr.review_date BETWEEN '2020-02-01' AND '2020-02-29'
  GROUP BY tf.title 
  ORDER BY max_rating DESC, results ASC 
  LIMIT 1
)
SELECT results FROM CTE 
UNION ALL
SELECT results FROM CTE2



--- Python
import pandas as pd
import numpy as np
import datetime
import json
import math
import re

def etl(trb_films,trb_film_ratings,trb_viewers):
    # Viewer with max reviews
    view= trb_viewers.merge(trb_film_ratings, on='viewer_id')
    view= view.groupby('full_name',as_index=False)['rating'].count()
    view= view.sort_values(by=['rating','full_name'], ascending=[False, True])
    view.rename(column={'full_name':'results'},inplace=True)

  # Films with highest average rating
    film= trb_films.merge(trb_film_ratings,on='film_id')
    film= film[(film['review_date'] >='2020-02-01') & (film['review_date']<='2020-02-29')]
    film= film.groupby('title',as_index=False)['rating'].mean()
    film= film.sort_values(by=['rating','title'],ascending=[False, True])
    film.rename(column={'title':'results'},inplace=True)
  
    return pd.concat([view['results'], film['results']],ignore_index=True)


--- PySpark
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, count, avg, desc

def etl(trb_film_ratings, trb_films, trb_viewers):
    viewer= (trb_film_ratings.groupBy('viewer_id')
             .agg(F.count('film_id').alias('rating_count'))
             .join(trb_viewers.select('viewer_id','full_name'), on='viewer_id',how='inner')
             .orderBy(F.desc('rating_count'),'full_name').limit(1)
             .select(col('full_name').alias('results')))

    filtered_ratings = trb_film_ratings.filter(
        (col("review_date") >= "2020-02-01") & (col("review_date") <= "2020-02-29")
    )

    movie_ratings = (
        filtered_ratings.groupBy("film_id")
        .agg(F.avg("rating").alias("avg_rating"))
        .join(trb_films.select("film_id", "title"), on="film_id", how="inner")
        .orderBy(F.desc("avg_rating"), "title")
        .limit(1) 
        .select(col("title").alias("results"))
    )

    return viewer.union(movie_ratings)




  
  