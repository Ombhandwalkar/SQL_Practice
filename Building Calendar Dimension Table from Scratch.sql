-- Building Calendar Dimension Table from Scratch
 CREATE DATABASE  cte;
SELECT CAST('2000-01-01'AS DATE) AS cal_date -- This will cast the string as DATE 
,YEAR(CAST('2000-01-01'AS DATE)) AS cal_year -- YEAR function CAST the string as cal_year
,DAYOFYEAR(CAST('2000-01-01'AS DATE)) AS cal_year_day -- DAYOFYEAR function CAST string as cal_year_day
,QUARTER(CAST('2000-01-01'AS DATE)) AS cal_quarter -- QUARTER function CAST string as cal_quarter
,MONTH(CAST('2000-01-01' AS DATE)) AS cal_month -- MONTH function CAST string as cal_month
,MONTHNAME(CAST('2000-01-01'AS DATE)) AS cal_month_name -- MONTHNAME function CAST string as cal_month_name
,DAY(CAST('2000-01-01' AS DATE)) AS cal_day -- DAY function CAST string as cal_day
,WEEK(CAST('2000-01-01' AS DATE))AS cal_week -- WEEK function CAST string as cal_week 
,DAYOFWEEK(CAST('2000-01-01' AS DATE))AS cal_week_day -- DAYOFWEEK function CAST string as cal_week_day
,DAYNAME(CAST('2000-01-01' AS DATE))AS cal_day_name ;-- DAYNAME function CAST string as as cal_day_name;

-- Above is example, we will put this in Recursice iteration
with cte AS(
	SELECT 1 AS id
	UNION ALL 
	SELECT id + 1 as id
	FROM cte 
	WHERE id<100)
SELECT * FROM cte;
-- Above example is recursive iteration will display 1 To 10 values

WITH cte AS (
SELECT CAST('2022-01-01' AS DATE) AS cal_date,
      YEAR(CAST('2022-01-01' AS DATE)) AS cal_year,
      DAYOFYEAR(CAST('2022-01-01' AS DATE)) AS cal_year_day,
      QUARTER(CAST('2022-01-01' AS DATE)) AS cal_quarter,
      MONTH(CAST('2022-01-01' AS DATE)) AS cal_month,
      MONTHNAME(CAST('2022-01-01' AS DATE)) AS cal_month_name,
      DAY(CAST('2022-01-01' AS DATE)) AS cal_month_day,
      WEEK(CAST('2022-01-01' AS DATE)) AS cal_week,
      DAYOFWEEK(CAST('2022-01-01' AS DATE)) AS cal_week_day,
      DAYNAME(CAST('2022-01-01' AS DATE)) AS cal_day_name
UNION ALL
-- RECURSIVE 
SELECT ADDDATE(cal_date, INTERVAL 1 DAY) AS cal_date,
      YEAR(ADDDATE(cal_date, INTERVAL 1 DAY)) AS cal_year,
      DAYOFYEAR(ADDDATE(cal_date, INTERVAL 1 DAY)) AS cal_year_day,
      QUARTER(ADDDATE(cal_date, INTERVAL 1 DAY)) AS cal_quarter,
      MONTH(ADDDATE(cal_date, INTERVAL 1 DAY)) AS cal_month,
      MONTHNAME(ADDDATE(cal_date, INTERVAL 1 DAY)) AS cal_month_name,
      DAY(ADDDATE(cal_date, INTERVAL 1 DAY)) AS cal_month_day,
      WEEK(ADDDATE(cal_date, INTERVAL 1 DAY)) AS cal_week,
      DAYOFWEEK(ADDDATE(cal_date, INTERVAL 1 DAY)) AS cal_week_day,
      DAYNAME(ADDDATE(cal_date, INTERVAL 1 DAY)) AS cal_day_name
    FROM cte 
    WHERE cal_date < CAST('2025-01-10' AS DATE) )
    SELECT * FROM cte


