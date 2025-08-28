You are working with a system that tracks the status of user accounts on a daily basis. Each day, every account has one entry that shows its status for that day.

Write a query to calculate the percentage of accounts that were active on December 31st, 2019 (status = 'open') but were marked as closed on January 1st, 2020 (status = 'closed'). The percentage should be calculated over the total number of accounts that were open on December 31st, 2019. Round the final result to two decimal places.








--- SQL
WITH open_accounts AS (
  SELECT account_id
  FROM ACR_account_closure
  WHERE date = '2019-12-31' AND status = 'open'
),
closed_next_day AS (
  SELECT account_id
  FROM ACR_account_closure
  WHERE date = '2020-01-01' AND status = 'closed'
),
active_and_closed AS (
  SELECT o.account_id
  FROM open_accounts o
  JOIN closed_next_day c ON o.account_id = c.account_id
)
SELECT 
  ROUND(COUNT(a.account_id) * 100.0 / (SELECT COUNT(*) FROM open_accounts), 2) AS percentage_closed
FROM active_and_closed a;


--- Python
import pandas as pd
import numpy as np
import datetime
import json
import math
import re

def etl(input_df):
    open= input_df[(input_df['date']=='2019-12-31') & (input_df['status']=='open')]
    close=input_df[(input_df['date']=='2020-00-01') & (input_df['status']=='closed')]
    df= open.merge(close, on='account_id')
    if len(open)>0:
      percentage_closed=round(len(df)*100/len(open),2)
    else:
      percentage_closed =0.0
    return pd.DataFrame({'percentage_closed':[percentage_closed]})




--- DBT
WITH open_accounts AS (
  SELECT account_id
  FROM {{ref("ACR_account_closure")}}
  WHERE date = '2019-12-31' AND status = 'open'
),
closed_next_day AS (
  SELECT account_id
  FROM {{ref("ACR_account_closure")}}
  WHERE date = '2020-01-01' AND status = 'closed'
),
active_and_closed AS (
  SELECT o.account_id
  FROM open_accounts o
  JOIN closed_next_day c ON o.account_id = c.account_id
)
SELECT 
  ROUND(COUNT(a.account_id) * 100.0 / (SELECT COUNT(*) FROM open_accounts), 2) AS percentage_closed
FROM active_and_closed a;
