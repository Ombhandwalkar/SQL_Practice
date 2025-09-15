/* ##########################################################################
   <<<<>>>> Scenario 1: Data duplicated based on SOME of the columns <<<<>>>>
   ########################################################################## */

-- Requirement: Delete duplicate data from cars table. Duplicate record is identified based on the model and brand name.

drop table if exists cars;
create table if not exists cars
(
    id      int,
    model   varchar(50),
    brand   varchar(40),
    color   varchar(30),
    make    int
);
insert into cars values (1, 'Model S', 'Tesla', 'Blue', 2018);
insert into cars values (2, 'EQS', 'Mercedes-Benz', 'Black', 2022);
insert into cars values (3, 'iX', 'BMW', 'Red', 2022);
insert into cars values (4, 'Ioniq 5', 'Hyundai', 'White', 2021);
insert into cars values (5, 'Model S', 'Tesla', 'Silver', 2018);
insert into cars values (6, 'Ioniq 5', 'Hyundai', 'Green', 2021);

select * from cars
order by model, brand;

--- Sol 1
DELETE FROM cars 
WHERE id IN (
	SELECT MAX(id)
	FROM cars
	GROUP BY model, brand
	HAVING COUNT(*)>1)

--- Sol 2
DELETE id FROM cars
WHERE id IN (
	SELECT c2.id
	FROM cars c1
	JOIN cars c2 ON  C1.model=c2.model 	AND c1.brand=c2.brand
	where c1.id<c2.id)

--- Sol 3
DELETE id FROM cars 
WHERE id IN (
	SELECT id FROM (
		SELECT *,ROW_NUMBER() OVER( PARTITION BY model, brand ORDER BY id) as rn
		FROM cars)x
		WHERE x.rn >1)


--- Sol 4
DELETE id FROM cars
WHERE id NOT IN (
	SELECT MIN(id)
	FROM cars
	GROUP BY model, brand
)