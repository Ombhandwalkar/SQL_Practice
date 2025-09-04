---
You are given a table bank_transactions that records every transaction made at a bank. Each transaction includes a unique ID, the amount transacted, and the timestamp of when it occurred. Your task is to identify the last transaction that happened on each day.

Write an SQL query that returns one transaction per day—the one with the latest timestamp. Your output should include the id, created_at, and transaction_value of each such transaction. The final results should be sorted by the created_at timestamp.

--- SQL

WITH CTE AS(
  SELECT *, ROW_NUMBER() OVER(PARTITION BY DATE(created_at) ORDER BY created_at DESC) AS rn 
  FROM dlt_daily_last
)
SELECT TO_CHAR(created_at,'YYYY-MM-DD HH24:MI:SS')AS created_at, transaction_value, id 
FROM CTE 
WHERE rn=1
ORDER BY created_at