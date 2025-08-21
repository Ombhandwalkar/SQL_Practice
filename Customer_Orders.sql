use omi;
-- Problem 1: Successful Purchases
-- Problem Statement: Find customers with successful multiple purchases in the last 1 month. Purchase is considered successful if they are not returned within 1 week of purchase. 

DROP TABLE IF EXISTS purchases;
CREATE TABLE purchases 
(
    purchase_id 	INT,
    customer_id 	INT,
    purchase_date 	DATE,
    return_date		DATE
);

INSERT INTO purchases VALUES
(1, 101, '2025-04-30', '2025-05-01'),
(2, 102, '2025-04-29', '2025-04-29'),
(3, 101, '2025-04-30', NULL),
(4, 101, '2025-04-05', NULL),
(5, 103, '2025-04-17', NULL),
(6, 102, '2025-04-29', NULL),
(7, 102, '2025-05-09', NULL),
(8, 103, '2025-05-01', '2025-05-10');

-- Solution
SELECT customer_id FROM purchases
WHERE purchase_date > CURDATE() - INTERVAL 1 MONTH 
AND (return_date IS NULL OR return_date > DATE_ADD(purchase_date, INTERVAL 7 DAY))
GROUP BY customer_id
HAVING COUNT(*) >1;




-- Problem 2: Latest Order Summary per Customer

-- Problem Statement: Write an SQL query to fetch the customer name, their latest order date and total value of the order. If a customer made multiple orders on the latest order date then fetch total value for all the orders in that day. If a customer has not done an order yet, display the “9999-01-01” as latest order date and 0 as the total order value.


DROP TABLE IF EXISTS customers;
CREATE TABLE customers 
(
    id     INT,
    name   VARCHAR(50)
);
INSERT INTO customers VALUES
(101, 'David'),
(102, 'Robin'),
(103, 'Carol'),
(104, 'Ali');

DROP TABLE IF EXISTS orders;
CREATE TABLE orders 
(
    id              INT,
    customer_id     INT,
    total_cost      DECIMAL,
    order_date      DATE
);
INSERT INTO orders VALUES
(1, 101, 100, '2025-04-15'),
(2, 102, 40, '2025-04-20'),
(3, 101, 80, '2025-03-12'),
(4, 101, 120, '2025-03-12'),
(5, 103, 60, '2025-04-20'),
(6, 103, 50, '2025-04-20');



-- Problem Statement: Write an SQL query to fetch the customer name, their latest order date and total value of the order. 
--- If a customer made multiple orders on the latest order date then fetch total value for all the orders in that day. 
--- If a customer has not done an order yet, display the “9999-01-01” as latest order date and 0 as the total order value.

-- Solution 
select * from orders;
select * from customers;

SELECT  customer,
		COALESCE(order_date,'9999-01-01') AS latest_order_date,
        COALESCE(SUM(total_cost),0) AS total_value
FROM(
		SELECT  o.*, c.name AS customer,
        RANK() OVER(PARTITION BY customer_id ORDER BY order_date DESC) as rnk
        FROM orders o 
        RIGHT JOIN customers c  ON c.id=o.customer_id)x
WHERE x.rnk =1
GROUP BY customer_id, customer, order_date;




-- Problem 3: Past Active Customers 

-- Problem Statement: Find customers who have not placed any orders yet in 2025 but had placed orders in every month of 2024 and had placed orders in at least 6 of the months in 2023. Display the customer name.


DROP TABLE IF EXISTS customers;
CREATE TABLE customers 
(
    id     INT PRIMARY KEY,
    name   VARCHAR(50)
);
INSERT INTO customers VALUES
(101, 'David Smith'),
(102, 'Nikhil Reddy'),
(103, 'Carol Tan'),
(104, 'Riya Sengupta'),
(105, 'Liam Patel'),
(106, 'Priya Nair'),
(107, 'James Canny');


DROP TABLE IF EXISTS orders;
CREATE TABLE orders 
(
    id              INT PRIMARY KEY,
    customer_id     INT,
    order_date      DATE
);
INSERT INTO orders VALUES
(1 , 101, '2024-01-05'),
(2 , 101, '2024-02-10'),
(3 , 101, '2024-03-03'),
(4 , 101, '2024-04-15'),
(5 , 101, '2024-05-20'),
(6 , 101, '2024-06-18'),
(7 , 101, '2024-07-12'),
(8 , 101, '2024-08-25'),
(9 , 101, '2024-09-30'),
(10, 101, '2024-10-22'),
(11, 101, '2024-11-02'),
(12, 101, '2024-12-17'),
(13, 102, '2024-01-10'),
(14, 102, '2024-02-15'),
(15, 102, '2024-03-10'),
(16, 102, '2024-04-05'),
(17, 102, '2024-05-07'),
(18, 102, '2024-06-12'),
(19, 102, '2024-07-14'),
(20, 102, '2024-08-16'),
(21, 103, '2024-01-01'),
(22, 103, '2024-04-01'),
(23, 103, '2024-07-01'),
(24, 103, '2024-10-01'),
(25, 104, '2024-02-20'),
(26, 104, '2024-05-20'),
(27, 104, '2024-08-20'),
(28, 105, '2024-01-01'),
(29, 105, '2024-02-01'),
(30, 105, '2024-03-01'),
(31, 105, '2024-04-01'),
(32, 105, '2024-05-01'),
(33, 105, '2024-06-01'),
(34, 105, '2024-07-01'),
(35, 105, '2024-08-01'),
(36, 105, '2024-09-01'),
(37, 105, '2024-10-01'),
(38, 105, '2024-11-01'),
(39, 105, '2024-12-01'),
(40, 102, '2024-08-10'),
(41, 102, '2024-07-05'),
(42, 102, '2024-06-06'),
(43, 102, '2024-05-26'),
(44, 106, '2024-01-02'),
(45, 106, '2024-02-13'),
(46, 106, '2024-03-05'),
(47, 106, '2024-04-16'),
(48, 106, '2024-05-26'),
(49, 106, '2024-06-17'),
(50, 106, '2024-07-19'),
(51, 106, '2024-08-20'),
(52, 106, '2024-09-12'),
(53, 106, '2024-10-22'),
(54, 106, '2024-11-03'),
(55, 106, '2024-12-14'),
(56, 105, '2025-01-28'),
(57, 105, '2025-04-21'),
(58, 103, '2025-03-22'),
(59, 101, '2023-01-15'),
(60, 101, '2023-02-11'),
(61, 101, '2023-03-13'),
(62, 101, '2023-05-10'),
(63, 101, '2023-06-12'),
(64, 101, '2023-07-11'),
(65, 101, '2023-12-12'),
(66, 107, '2024-01-22'),
(67, 107, '2024-02-28'),
(68, 107, '2024-03-31'),
(69, 107, '2024-04-30'),
(70, 107, '2024-05-30'),
(71, 107, '2024-06-30'),
(72, 107, '2024-07-31'),
(73, 107, '2024-08-31'),
(74, 107, '2024-09-30'),
(75, 107, '2024-10-31'),
(76, 107, '2024-11-30'),
(77, 107, '2024-12-28'),
(78, 107, '2024-12-31'),
(79, 107, '2023-07-31'),
(80, 107, '2023-08-31'),
(81, 107, '2023-09-30'),
(82, 107, '2023-10-31'),
(83, 107, '2023-11-30'),
(84, 107, '2023-12-31'),
(85, 105, '2023-01-21'),
(86, 105, '2023-03-09'),
(87, 105, '2023-04-20'),
(88, 105, '2023-06-10'),
(89, 105, '2023-10-10'),
(90, 105, '2023-11-21');


select * from customers;
select * from orders;

WITH customer_2025 AS (
		SELECT * FROM orders
        WHERE EXTRACT(YEAR FROM order_date)=2025),
	
    customer_2024 AS (
		SELECT customer_id
        FROM orders
        WHERE EXTRACT(YEAR FROM order_date)=2024
        GROUP BY customer_id
        HAVING COUNT(DISTINCT EXTRACT(MONTH FROM order_date) >=12)),
        
	customer_2023 AS (
    SELECT customer_id
	FROM orders
    WHERE EXTRACT(YEAR FROM order_date)=2023
    GROUP BY customer_id
    HAVING COUNT(DISTINCT EXTRACT(MONTH FROM order_date) >=6))
    
SELECT c.name FROM customers c
JOIN customer_2024 c24 ON c24.customer_id=c.id
JOIN customer_2023 c23 ON c23.customer_id=c.id
WHERE c.id NOT IN (SELECT customer_id FROM customer_2025);


-- solution 2
WITH cte AS(
		SELECT customer_id, c.name AS customer,
				EXTRACT(YEAR FROM order_date) AS order_year,
                COUNT(DISTINCT EXTRACT(MONTH FROM order_date)) AS monthly_unique_order
		FROM orders o
        JOIN customers c ON c.id=o.customer_id
        GROUP BY customer_id,c.name,order_year)
        
select c23.customer
FROM cte c23
JOIN cte c24 ON  c24.customer_id=c23.customer_id
WHERE C23.order_year=2023 AND c24.order_year=2024
AND   c23.monthly_unique_order >=6 AND c24.monthly_unique_order >=12
AND c23.customer_id NOT IN (SELECT customer_id FROM cte WHERE order_year=2025);
        
        





