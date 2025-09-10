-- Use Case 1:
drop table if exists listens;
create table listens
(
	user_id 	int,
	song_id		int,
	day			date
);
drop table if exists friendship;
create table friendship
(
	user1_id 	int,
	user2_id	int
);

insert into listens values(1,10,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(1,11,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(1,12,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(2,10,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(2,11,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(2,12,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(3,10,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(3,11,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(3,12,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(4,10,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(4,11,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(4,13,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(5,10,to_date('2021-03-16','yyyy-mm-dd'));
insert into listens values(5,11,to_date('2021-03-16','yyyy-mm-dd'));
insert into listens values(5,12,to_date('2021-03-16','yyyy-mm-dd'));

insert into friendship values(1,2);

select * from listens;
select * from friendship;

WITH CTE AS(
		SELECT DISTINCT * 
		FROM listens),
valid_users AS(
		SELECT user_id, day 
		FROM CTE
		GROUP BY user_id, day
		HAVING COUNT(*) >=3
),
CTE2 AS(
		SELECT l1.user_id  AS user_id, l2.user_id AS recommended_id, l1.day, l2.day
		FROM CTE l1
		JOIN CTE l2 
		ON l1.user_id < l2.user_Id AND l1.day = l2.day AND l1.song_id=l2.song_id
		WHERE (l1.user_id, l2.user_id) NOT IN(SELECT user1_id, user2_id FROM friendship)
		GROUP BY l1.user_id, l2.user_id, l1.day, l2.day
		HAVING COUNT(1)>=3
)
SELECT user_id, recommended_id FROM CTE2
UNION
SELECT recommended_id, user_id FROM CTE2
ORDER BY user_id, recommended_id


















