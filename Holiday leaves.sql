/*
PROBLEM STATEMENT: 
Given vacation_plans tables shows the vacations applied by each employee during the year 2024. 
Leave_balance table has the available leaves for each employee.
Write an SQL query to determine if the vacations applied by each employee can be approved or not based on the available leave balance. 
If an employee has enough available leaves then mention the status as "Approved" else mention "Insufficient Leave Balance".
Assume there are no public holidays during 2024. weekends (sat & sun) should be excluded while calculating vacation days. 
*/

drop table if exists vacation_plans;
create table vacation_plans
(
	id 			int primary key,
	emp_id		int,
	from_dt		date,
	to_dt		date
);
insert into vacation_plans values(1,1, '2024-02-12', '2024-02-16');
insert into vacation_plans values(2,2, '2024-02-20', '2024-02-29');
insert into vacation_plans values(3,3, '2024-03-01', '2024-03-31');
insert into vacation_plans values(4,1, '2024-04-11', '2024-04-23');
insert into vacation_plans values(5,4, '2024-06-01', '2024-06-30');
insert into vacation_plans values(6,3, '2024-07-05', '2024-07-15');
insert into vacation_plans values(7,3, '2024-08-28', '2024-09-15');


drop table if exists leave_balance;
create table leave_balance
(
	emp_id			int,
	balance			int
);
insert into leave_balance values (1, 12);
insert into leave_balance values (2, 10);
insert into leave_balance values (3, 26);
insert into leave_balance values (4, 20);
insert into leave_balance values (5, 14);

select * from vacation_plans;
select * from leave_balance;

WITH RECURSIVE CTE AS (
		WITH cte_data AS
			(SELECT v.id, 
					v.emp_id,
					v.from_dt, 
					v.to_dt,
					l.balance AS leave_balance, 
					COUNT(dates) AS vacation_days,
					ROW_NUMBER() OVER (PARTITION BY v.emp_id ORDER BY v.emp_id, v.id) AS rn
			FROM vacation_plans v
			CROSS JOIN LATERAL(
					SELECT CAST(dates AS DATE) AS dates, TRIM(TO_CHAR(dates, 'Day')) AS day
					FROM generate_series(v.from_dt::DATE, v.to_dt::DATE, '1 Day') AS dates) d
			JOIN leave_balance l ON v.emp_id=l.emp_id
			WHERE day NOT IN('Saturday','Sunday')
			GROUP BY v.id, v.emp_id, v.from_dt, v.to_dt, l.balance)	

			
			SELECT *, (leave_balance - vacation_days) AS remaining_balance
			FROM cte_data
			WHERE rn=1
			UNION ALL
			SELECT cd.*, (cte.remaining_balance- cd.vacation_days) AS remaining_balance
			FROM cte 
			JOIN cte_data cd ON cd.rn = cte.rn+1 AND cd.emp_id=cte.emp_id
			)

SELECT *,
	CASE WHEN remaining_balance >= 0 THEN 'Approved' ELSE 'Insufficient leave balance' END AS status
FROM CTE















