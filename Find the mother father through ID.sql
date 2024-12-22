USE OMI;
DROP TABLE company;
create table company_revenue 
(
company varchar(100),
year int,
revenue int
);

insert into company_revenue values 
('ABC1',2000,100),('ABC1',2001,110),('ABC1',2002,120),('ABC2',2000,100),('ABC2',2001,90),('ABC2',2002,120)
,('ABC3',2000,500),('ABC3',2001,400),('ABC3',2002,600),('ABC3',2003,800);

SELECT * FROM company_revenue;

WITH cte AS(SELECT *,LAG(revenue,1,0) OVER(PARTITION BY company ORDER BY year) AS prev_year,
revenue-LAG(revenue,1,0) OVER(PARTITION BY company ORDER BY year) AS rev_diff,
COUNT(1) OVER(PARTITION BY company) AS cnt
FROM company_revenue)
SELECT company FROM cte
WHERE rev_diff>0
GROUP BY company,cnt
HAVING cnt=count(1);

-- Q2 Find the mother father through ID

create table people
(id int primary key not null,
 name varchar(20),
 gender char(2));
create table relations
(
    c_id int,
    p_id int,
    FOREIGN KEY (c_id) REFERENCES people(id),
    foreign key (p_id) references people(id)
);

insert into people (id, name, gender)
values
    (107,'Days','F'),
    (145,'Hawbaker','M'),
    (155,'Hansel','F'),
    (202,'Blackston','M'),
    (227,'Criss','F'),
    (278,'Keffer','M'),
    (305,'Canty','M'),
    (329,'Mozingo','M'),
    (425,'Nolf','M'),
    (534,'Waugh','M'),
    (586,'Tong','M'),
    (618,'Dimartino','M'),
    (747,'Beane','M'),
    (878,'Chatmon','F'),
    (904,'Hansard','F');

insert into relations(c_id, p_id)
values
    (145, 202),
    (145, 107),
    (278,305),
    (278,155),
    (329, 425),
    (329,227),
    (534,586),
    (534,878),
    (618,747),
    (618,904);


SELECT * FROM people;
SELECT * FROM relations;

WITH ct AS (SELECT r.c_id,p.name AS mother_name FROM relations r
INNER JOIN people p ON r.p_id=p.id AND GENDER='F'),
CT1 AS (SELECT r.c_id,p.name AS father_name FROM relations r
INNER JOIN people p ON r.p_id=p.id AND GENDER='M')

SELECT name,mother_name,father_name from ct JOIN ct1 ON ct.c_id=ct1.c_id
INNER JOIN people ON ct.c_id=people.id




