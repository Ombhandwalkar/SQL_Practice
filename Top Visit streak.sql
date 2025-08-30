---
You are given a dataset containing user event logs with their visit timestamps.
Your task is to determine the top five users who achieved the longest continuous streak of platform visits.

A continuous streak means the user has visited the platform at least once every day without missing any consecutive days.


--- SQL


WITH visit_dates AS (
  SELECT DISTINCT user_id, DATE(created_at) AS visit_date
  FROM tvs_event
),
visit_with_rank AS (
  SELECT 
    user_id,
    visit_date,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY visit_date) -
    EXTRACT(DAY FROM visit_date) AS streak_group
  FROM visit_dates
),
streaks AS (
  SELECT 
    user_id,
    COUNT(*) AS streak_length
  FROM visit_with_rank
  GROUP BY user_id, streak_group
)
SELECT user_id, MAX(streak_length) AS streak_length
FROM streaks
GROUP BY user_id
ORDER BY streak_length DESC
LIMIT 5;
