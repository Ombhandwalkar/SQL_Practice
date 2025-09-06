--- You’re working with transaction and user records for an online store. Your goal is to identify loyal customers who made more than 3 purchases in both 2019 and 2020.

Only users who have made at least 4 transactions in each of these years should be included in the final result.

--- SQL

WITH CTE AS (
  SELECT user_id
  FROM csf_transactions
  WHERE EXTRACT(YEAR FROM created_at) IN (2019,2020)
  GROUP BY user_id
  HAVING SUM(CASE WHEN EXTRACT(YEAR FROM created_at)=2019 THEN 1 ELSE 0 END)>3 
  AND
         SUM(CASE WHEN EXTRACT(YEAR FROM created_at)=2020 THEN 1 ELSE 0 END)>3
)
SELECT name AS customer_name
FROM CTE c
JOIN csf_users cc 
ON c.user_id=cc.id