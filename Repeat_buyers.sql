You’re working with a dataset that captures purchase transactions made by users. Each entry in this dataset represents a specific product purchase made by a user at a particular time.

--- SQL

WITH CTE AS(
  SELECT user_id, MIN(DATE(created_at)) AS first_transaction
  FROM st_transactions
  GROUP BY user_id
)
SELECT COUNT(t.user_id) AS num_of_upsold_customers
FROM st_transactions t 
JOIN CTE c 
ON c.user_id=t.user_id
WHERE  DATE(t.created_at) > c.first_transaction