-- Find length of comma seperated values in items field

drop table if exists item;
create table item
(
	id		int,
	items	varchar(50)
);
insert into item values(1, '22,122,1022');
insert into item values(2, ',6,0,9999');
insert into item values(3, '100,2000,2');
insert into item values(4, '4,44,444,4444');

select * from item;

SELECT id, STRING_AGG(length, ',') AS length
FROM (
		SELECT *, LENGTH(UNNEST(STRING_TO_ARRAY(items,',')))::VARCHAR AS length
		FROM item) x
GROUP BY id
ORDER BY id
