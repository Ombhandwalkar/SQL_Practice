CREATE TABLE events (
ID int,
event varchar(255),
YEAR INt,
GOLD varchar(255),
SILVER varchar(255),
BRONZE varchar(255)
);

delete from events;

INSERT INTO events VALUES (1,'100m',2016, 'Amthhew Mcgarray','donald','barbara');
INSERT INTO events VALUES (2,'200m',2016, 'Nichole','Alvaro Eaton','janet Smith');
INSERT INTO events VALUES (3,'500m',2016, 'Charles','Nichole','Susana');
INSERT INTO events VALUES (4,'100m',2016, 'Ronald','maria','paula');
INSERT INTO events VALUES (5,'200m',2016, 'Alfred','carol','Steven');
INSERT INTO events VALUES (6,'500m',2016, 'Nichole','Alfred','Brandon');
INSERT INTO events VALUES (7,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events VALUES (8,'200m',2016, 'Thomas','Dawn','catherine');
INSERT INTO events VALUES (9,'500m',2016, 'Thomas','Dennis','paula');
INSERT INTO events VALUES (10,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events VALUES (11,'200m',2016, 'jessica','Donald','Stefeney');
INSERT INTO events VALUES (12,'500m',2016,'Thomas','Steven','Catherine');


-- Find the gold winner swimmer who only won the gold medal 
SELECT gold as player_name, COUNT(1)  as no_of_medals
FROM events 
WHERE  gold NOT IN (SELECT bronze FROM  events UNION ALL select silver FROM events)
GROUP BY gold;





-- Business Days Excluding Weekends and Public Holidays
create table tickets
(
ticket_id varchar(10),
create_date date,
resolved_date date
);
delete from tickets;
insert into tickets values
(1,'2022-08-01','2022-08-03')
,(2,'2022-08-01','2022-08-12')
,(3,'2022-08-01','2022-08-16');
create table holidays
(
holiday_date date
,reason varchar(100)
);
delete from holidays;
insert into holidays values
('2022-08-11','Rakhi'),('2022-08-15','Independence day');
SELECT * FROM tickets;
SELECT ticket_id,create_date,resolved_date,COUNT(holiday_date)AS holidays,
DATEDIFF(resolved_date,create_date)AS actual_days 
,TIMESTAMPDIFF(WEEK,create_date,resolved_date)AS weeks
,TIMESTAMPDIFF(DAY,create_date,resolved_date)-2*TIMESTAMPDIFF(WEEK,create_date,resolved_date) AS business_days FROM tickets
LEFT JOIN holidays ON holiday_date BETWEEN create_date AND resolved_date
GROUP BY ticket_id,create_date,resolved_date