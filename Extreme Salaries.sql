---
You are given employee data with details like salary, department, and personal identifiers.
Your task is to identify the employee(s) with the highest and lowest salary in the dataset.

Your output should include:

worker_id

salary

department

a new column salary_type:

'Highest Salary' if the employee earns the maximum salary

'Lowest Salary' if the employee earns the minimum salary

 
--- SQL
-- Write query here
-- TABLE NAME: `es_extreme_salaries`
WITH CTE AS (
  SELECT worker_id, salary, department,
  CASE WHEN salary= MAX(salary) OVER(ORDER BY salary DESC) THEN 'Highest Salary'
       WHEN salary= MIN(salary) OVER(ORDER BY salary)THEN 'Lowest Salary'
  ELSE NULL
  END AS salary_type
  FROM es_extreme_salaries  
)
SELECT * FROM CTE 
WHERE salary_type IN ('Highest Salary','Lowest Salary')
ORDER BY salary DESC


--- Python 
import pandas as pd
import numpy as np
import datetime
import json
import math
import re

def etl(input_df):
    highest_salary= input_df['salary'].max()
    lowest_salary=  input_df['salary'].min()
  
    high= input_df[input_df['salary']==highest_salary]
    high['salary_type']='Highest Salary'
  
    low= input_df[input_df['salary']==lowest_salary]
    low['salary_type']='Lowest Salary'
  
    df= pd.concat([high, low],ignore_index=True)
    return df[['worker_id','salary','department','salary_type']]
  
  
--- DBT
WITH CTE AS (
  SELECT worker_id, salary, department,
  CASE WHEN salary= MAX(salary) OVER(ORDER BY salary DESC) THEN 'Highest Salary'
       WHEN salary= MIN(salary) OVER(ORDER BY salary)THEN 'Lowest Salary'
  ELSE NULL
  END AS salary_type
  FROM {{ref("es_extreme_salaries")}}  
)
SELECT * FROM CTE 
WHERE salary_type IN ('Highest Salary','Lowest Salary')
ORDER BY salary DESC





