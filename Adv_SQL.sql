USE OMI;
DROP table emp;
create table emp(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);


insert into emp
values (1, 'Ankit', 100,10000, 4, 39);
insert into emp
values (2, 'Mohit', 100, 15000, 5, 48);
insert into emp
values (3, 'Vikas', 100, 10000,4,37);
insert into emp
values (4, 'Rohit', 100, 5000, 2, 16);
insert into emp
values (5, 'Mudit', 200, 12000, 6,55);
insert into emp
values (6, 'Agam', 200, 12000,2, 14);
insert into emp
values (7, 'Sanjay', 200, 9000, 2,13);
insert into emp
values (8, 'Ashish', 200,5000,2,12);
insert into emp
values (1, 'Saurabh',900,12000,2,51);

SELECT * FROM emp;

-- TOp 2 Highest salaried employee from each department
SELECT * FROM ( SELECT  * , 
rank()over(partition by department_id order by salary DESC) AS rnk,
DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) denc_rn
FROM emp)A
WHERE rnk<=2;

-- Top Products by sale
WITH cte AS (select category, product_id,sum(sale) as sales
from orders 
GROUP BY category,product_id)
SELECT *,ROW_NUMBER()OVER(PARTITION BY category ORDER BY SALES DESC) AS rn 
FROM cte
WHERE rn<=5;


-- YOY sales
WITH cte AS(SELECT YEAR(order_date) AS year_order, SUM(sales) AS sales
FROM orders
GROUP BY YEAR(order_date))
,cte2 AS (
SELECT LAG(sales,1,sales) OVER(ORDER BY year_date) AS previous_year_sales
FROM cte)
SELECT * ,(sales-previous_year_sales)*100/previous_year_sales AS YOY 
FROM cte2;

-- Comulative SUm
WITH cte AS (SELECT YEAR(order_date) AS year_date ,SUM(sales) AS sales 
FROM  orders 
GROUP BY YEAR(order_date))
SELECT * , SUM(sales) OVER (ORDER BY year_date) AS cumulative_sum
FROM cte;


--- 4 months cumulative sales
WITH cte AS (SELECT YEAR(order_date) AS year_date,MONTH(order_date) as month_date  ,SUM(sales) AS sales 
FROM  orders 
GROUP BY YEAR(order_date),MONTH(order_date))
SELECT * , SUM(sales) OVER (ORDER BY year_date,month_date ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING ) AS cumulative_sum
FROM cte;

-- Convert rows into columns
SELECT YEAR(order_date) AS year,
SUM(CASE WHEN  category='Furniture' THEN sales ELSE 0 END) AS fur_sales,
SUM(CASE WHEN  category='fur_supply' THEN sales ELSE 0 END)AS os_sales,
SUM(CASE WHEN  category='Technology' THEN sales ELSE 0 END)AS tech_sales
FROM orders
GROUP BY YEAR(order_date)