USE OMI;
CREATE TABLE employees  (employee_id int,employee_name varchar(15), email_id varchar(15) );
delete from employees;
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('101','Liam Alton', 'li.al@abc.com');
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('102','Josh Day', 'jo.da@abc.com');
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('103','Sean Mann', 'se.ma@abc.com'); 
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('104','Evan Blake', 'ev.bl@abc.com');
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('105','Toby Scott', 'jo.da@abc.com');
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('106','Anjali Chouhan', 'JO.DA@ABC.COM');
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('107','Ankit Bansal', 'AN.BA@ABC.COM');

-- If there are any duplicates in the email id, then fetch only lower case email id only
-- The problem is MYSQL is not case sensitive
-- We filtering these by ASCII values
-- lower case values have higher ASCII number

WITH cte AS(select * 
,ASCII(email_id),RANK()OVER(PARTITION BY email_id ORDER BY ASCII(email_id) DESC) AS rn
from employees)
SELECT * FROM cte
WHERE rn=1