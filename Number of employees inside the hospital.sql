create table hospital ( emp_id int
, action varchar(10)
, timee datetime);
DROP TABLE hospital;
insert into hospital values ('1', 'in', '2019-12-22 09:00:00');
insert into hospital values ('1', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:00:00');
insert into hospital values ('2', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:30:00');
insert into hospital values ('3', 'out', '2019-12-22 09:00:00');
insert into hospital values ('3', 'in', '2019-12-22 09:15:00');
insert into hospital values ('3', 'out', '2019-12-22 09:30:00');
insert into hospital values ('3', 'in', '2019-12-22 09:45:00');
insert into hospital values ('4', 'in', '2019-12-22 09:45:00');
insert into hospital values ('5', 'out', '2019-12-22 09:40:00');


-- find number of employees inside the hospital
WITH cte AS(
SELECT *, RANK() OVER(PARTITION BY emp_id ORDER BY timee DESC)AS rnk FROM hospital)
SELECT * FROM cte 
WHERE rnk=1 AND action='in';


DROP TABLE airbnb_searches;
create table airbnb_searches 
(
user_id int,
date_searched date,
filter_room_types varchar(200)
);
SELECT * from airbnb_searches;
insert into airbnb_searches values
(1,'2022-01-01','entire home,private room')
,(2,'2022-01-02','entire home,shared room')
,(3,'2022-01-02','private room,shared room')
,(4,'2022-01-03','private room')
;

-- Convert Comma Separated Values into Rows
with cte as (
select sum(case when filter_room_types like '%private%' then 1 else 0 end) as pr,
sum(case when filter_room_types like '%entire%' then 1 else 0 end) as en,
sum(case when filter_room_types like '%shared%' then 1 else 0 end) as sh
from airbnb_searches )
select 'private type' as  room_type,pr from cte as val 
union all
select 'entry type' as  room_type,en from cte as val 
union all
select 'shared type' as  room_type,sh from cte as val;
	
    
    
    
CREATE TABLE emp_salary
(
    emp_id INTEGER  NOT NULL,
    name NVARCHAR(20)  NOT NULL,
    salary NVARCHAR(30),
    dept_id INTEGER
);


INSERT INTO emp_salary
(emp_id, name, salary, dept_id)
VALUES(101, 'sohan', '3000', '11'),
(102, 'rohan', '4000', '12'),
(103, 'mohan', '5000', '13'),
(104, 'cat', '3000', '11'),
(105, 'suresh', '4000', '12'),
(109, 'mahesh', '7000', '12'),
(108, 'kamal', '8000', '11');
SELECT * FROM emp_salary;

-- Employee who have same salary in same department
WITH cte AS(SELECT dept_id,salary FROM emp_salary
GROUP BY dept_id,salary 
HAVING COUNT(1) >1)
SELECT es.* FROM emp_salary ES
INNER JOIN cte ct ON ES.dept_id=ct.dept_id AND ES.salary=ct.salary