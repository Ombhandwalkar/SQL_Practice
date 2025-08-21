drop table if exists Q4_data;
create table Q4_data
(
	id			int,
	name		varchar(20),
	location	varchar(20)
);
insert into Q4_data values(1,null,null);
insert into Q4_data values(2,'David',null);
insert into Q4_data values(3,null,'London');
insert into Q4_data values(4,null,null);
insert into Q4_data values(5,'David',null);

select * from Q4_data;

--  We will use the basic function of SQL which is MININUM . We are going to use the MIN function on the name and location column. 
--- By doing this we will get the minimum value in the varchar . But obviously we have only two value which are smae it wiil return only one value.
-- If you are talking about the locaion column we will use the function to fetch the london value. 
--- So the catch over is the in the MIninum funciton for the varchar, it ignores the null so that you will get the actual non null value .

SELECT MIN(id), MIN(name), MIN(location) FROM Q4_data	