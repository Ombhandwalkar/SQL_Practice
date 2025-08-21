drop table if exists salary;

CREATE TABLE salary
( 	
	emp_id int,
    emp_name varchar(30),
    base_salary int 
);

INSERT INTO salary values(1,'Rohan', 5000);
INSERT INTO salary values(2,'Alex',6000);
INSERT INTO salary values(3,'Maryam',7000);

drop table if exists income;
CREATE TABLE income
(
	id int,
    income varchar(20),
    perventage int 
);
INSERT INTO income values(1,'Basic',100);
INSERT INTO income values(2,'Allowance',4);
INSERT INTO income VALUES(3,'Other',6);

DROP TABLE IF EXISTS deduction;
CREATE TABLE deduction
(
		id int,
        deduction varchar(20),
        percentage int 
);

insert into deduction values(1,'Insurance', 5);
insert into deduction values(2,'Health', 6);
insert into deduction values(3,'House', 4);


drop table if exists emp_transaction;
create table emp_transaction
(
	emp_id		int,
	emp_name	varchar(50),
	trns_type	varchar(20),
	amount		numeric
);


--- Solution
SELECT * FROM salary;
SELECT * FROM income;
SELECT * FROM deduction;
SELECT * FROM emp_transaction;

SELECT 
	s.emp_id,s.emp_name,x.income,
    CASE WHEN salary='Basic' THEN ROUND(base_salary * x.percentage)/100),2) 
	CASE WHEN salary='Allowance' THEN ROUND(base_salary * x.percentage)/100),2)

 FROM salary
CROSS JOIN ( 
SELECT * FROM income
UNION
SELECT * FROM deduction
)x
