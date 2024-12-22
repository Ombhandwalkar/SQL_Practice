USE OMI;
drop table employee;
create table employee 
(
emp_name varchar(10),
dep_id int,
salary int
);
delete from employee;
insert into employee values 
('Siva',1,30000),('Ravi',2,40000),('Prasad',1,50000),('Sai',2,20000);

SELECT * FROM employee;
-- Max salary of employee per department
WITH cte AS(
SELECT dep_id,
MIN(salary)as min_salary,MAX(salary) AS max_salary FROM employee
GROUP BY dep_id)
SELECT e.dep_id,
MIN(CASE WHEN salary=max_salary THEN emp_name ELSE NULL END) AS max_salary_emp,
MAX(CASE WHEN salary=min_salary THEN emp_name ELSE NULL END) AS min_salary_emp
FROM employee e
INNER JOIN cte ON e.dep_id=cte.dep_id
GROUP BY dep_id;


-- Method 2
 
WITH CTE AS (SELECT *, 
ROW_NUMBER() OVER(PARTITION BY dep_id ORDER BY salary ASC) AS min_salary,
ROW_NUMBER() OVER(PARTITION BY dep_id ORDER BY salary DESC)AS max_salary
FROM employee)
SELECT *,
CASE WHEN min_salary=1 THEN emp_name END AS mix_salary,
CASE WHEN max_salary=1 THEN emp_name END AS max_salary
FROM CTE;


-- Q2
create table call_start_logs
(
phone_number varchar(10),
start_time datetime
);
insert into call_start_logs values
('PN1','2022-01-01 10:20:00'),('PN1','2022-01-01 16:25:00'),('PN2','2022-01-01 12:30:00')
,('PN3','2022-01-02 10:00:00'),('PN3','2022-01-02 12:30:00'),('PN3','2022-01-03 09:20:00');
create table call_end_logs
(
phone_number varchar(10),
end_time datetime
);
insert into call_end_logs values
('PN1','2022-01-01 10:45:00'),('PN1','2022-01-01 17:05:00'),('PN2','2022-01-01 12:55:00')
,('PN3','2022-01-02 10:20:00'),('PN3','2022-01-02 12:50:00'),('PN3','2022-01-03 09:40:00')
;

SELECT A.phone_number,A.start_time,B.phone_number,B.end_time,timediff(end_time,start_time) FROM 
(SELECT *,ROW_NUMBER() OVER(PARTITION BY phone_number ORDER BY start_time ASC)AS rn  FROM call_start_logs)A
INNER JOIN
(SELECT *,ROW_NUMBER() OVER(PARTITION BY phone_number ORDER BY end_time   ASC)AS rn  FROM call_end_logs)B
ON A.phone_number=B.phone_number AND A.rn=B.rn;


-- Q3
create table family 
(
person varchar(5),
type varchar(10),
age int
);
delete from family ;
insert into family values ('A1','Adult',54)
,('A2','Adult',53),('A3','Adult',52),('A4','Adult',58),('A5','Adult',54),('C1','Child',20),('C2','Child',19),('C3','Child',22),('C4','Child',15);
SELECT * FROM family;

WITH cte AS(SELECT *,ROW_NUMBER() OVER(ORDER BY age DESC)AS rn FROM family WHERE type='Adult')
, cte1 AS (SELECT *,ROW_NUMBER() OVER(ORDER BY age ASC)AS rn FROM family WHERE type='Child')
SELECT a.person,c.person,a.age AS adult_age,c.age AS child_age FROM cte a 
LEFT JOIN cte1 c ON a.rn=c.rn
