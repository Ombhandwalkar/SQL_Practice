CREATE TABLE date_functions_demo (
    id INT ,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
 system_date varchar(10)
);

INSERT INTO date_functions_demo (id,start_date, end_date, created_at, updated_at,system_date) VALUES 
(1,'2024-01-01', '2024-12-31', '2024-01-01 10:00:00', '2024-12-31 23:59:59','12/30/2024'),
(2,'2023-06-15', '2024-06-15', '2023-06-15 08:30:00', '2024-06-15 17:45:00','08/15/2024'),
(3,'2022-05-20', '2023-05-20', '2022-05-20 12:15:00', '2023-05-20 18:00:00','10/21/2024');

-- Current time 
SELECT NOW();
SELECT CURRENT_TIMESTAMP();

-- Current date
SELECT CURRENT_DATE();

-- Current Time
SELECT CURRENT_TIME();

-- DATE()
SELECT id,created_at, DATE(created_at),CAST(created_at AS DATE) FROM date_functions_demo;

-- DATE_FROMAT()
SELECT id,start_date,end_date, DATE_FORMAT(start_date,"%d-%m-%Y") FROM date_functions_demo;

-- DATEDIFF()
SELECT id, start_date,end_date,DATEDIFF(end_date,start_date) FROM date_functions_demo;
SELECT id, start_date,end_date,end_date-start_date FROM date_functions_demo;

-- DATE ADD
SELECT id, start_date,DATE_ADD(start_date,INTERVAL 1 DAY) FROM date_functions_demo;

-- DATE SUB
SELECT id, start_date,DATE_SUB(start_date,INTERVAL 1 DAY) FROM date_functions_demo;

-- MONTH()
SELECT id, start_date,MONTH(start_date) FROM date_functions_demo;

-- YEAR()
SELECT id, start_date,YEAR(start_date) FROM date_functions_demo;

-- DAYOFWEEK()
SELECT id, start_date,DAYOFWEEK(start_date) FROM date_functions_demo;

-- DAYOFYEAR()
SELECT id, start_date,DAYOFYEAR(start_date) FROM date_functions_demo;

-- DAYOFWEEK()
SELECT id, start_date,DAYOFMONTH(start_date) FROM date_functions_demo;

-- DAYNAME()
SELECT id, start_date,DAYNAME(start_date) FROM date_functions_demo;

-- STR TO DATE
SELECT id,start_date,system_date, STR_TO_DATE(system_date,"%m-%d-%Y") FROM date_functions_demo;

-- TIMESTAMP DIFF
SELECT *, TIMESTAMPDIFF(minute,created_at,updated_at) as ss FROM date_functions_demo;
SELECT *, TIMESTAMPDIFF(HOUR,created_at,updated_at) as ss FROM date_functions_demo;
SELECT *, TIMESTAMPDIFF(SECOND,created_at,updated_at) as ss FROM date_functions_demo;
SELECT *, TIMESTAMPDIFF(DAY,created_at,updated_at) as ss FROM date_functions_demo;

-- LAST DAY
select id,start_date, LAST_DAY(start_date) from date_functions_demo;

-- EXTRACT
select id,start_date, EXTRACT(MONTH FROM start_date) from date_functions_demo