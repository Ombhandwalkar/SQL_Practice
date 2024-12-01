Create table orders
(
    Id int primary key ,
    Continent nvarchar(50),
    Country nvarchar(50),
    City nvarchar(50),
    amount int
);
Insert into orders values(2,'Asia','India','Bangalore',1000);
Insert into orders values(1,'Asia','India','Chennai',2000);
Insert into orders values(3,'Asia','Japan','Tokyo',4000);
Insert into orders values(4,'Asia','Japan','Hiroshima',5000);
Insert into orders values(5,'Europe','United Kingdom','London',1000);
Insert into orders values(6,'Europe','United Kingdom','Manchester',2000);
Insert into orders values(7,'Europe','France','Paris',4000);
Insert into orders values(8,'Europe','France','Cannes',5000);
;

SELECT * FROM orders;

-- Rollup Function . It is use to generate Subtotal and Grandtotal of the dataset .
SELECT Continent,Country,City,SUM(amount) as total_amount
FROM orders
GROUP BY Continent,Country,City WITH ROLLUP;


