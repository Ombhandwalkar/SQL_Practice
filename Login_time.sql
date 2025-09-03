/*
PROBLEM STATEMENT: Given table provides login and logoff details of one user.
Generate a report to reqpresent the different periods (in mins) when user was logged in.
*/
drop table if exists login_details;
create table login_details
(
	times	time,
	status	varchar(3)
);
insert into login_details values('10:00:00', 'on');
insert into login_details values('10:01:00', 'on');
insert into login_details values('10:02:00', 'on');
insert into login_details values('10:03:00', 'off');
insert into login_details values('10:04:00', 'on');
insert into login_details values('10:05:00', 'on');
insert into login_details values('10:06:00', 'off');
insert into login_details values('10:07:00', 'off');
insert into login_details values('10:08:00', 'off');
insert into login_details values('10:09:00', 'on');
insert into login_details values('10:10:00', 'on');
insert into login_details values('10:11:00', 'on');
insert into login_details values('10:12:00', 'on');
insert into login_details values('10:13:00', 'off');
insert into login_details values('10:14:00', 'off');
insert into login_details values('10:15:00', 'on');
insert into login_details values('10:16:00', 'off');
insert into login_details values('10:17:00', 'off');

select * from login_details;

	
	with cte as 
		(select distinct first_value(times) over(partition by grp order by grp,times) as log_on
		, last_value(times) over(partition by grp order by grp,times
								range between unbounded preceding and unbounded following) as last_log_on
		from (	select times, status, rn-row_number() over(order by times) as grp
				from (select *, row_number() over(order by times) as rn
					  from login_details) x
				where status='on') y),
	cte_final as 
		(select log_on, lead(times) over(order by times) as log_off
		from login_details l 
		left join cte on cte.last_log_on=l.times)
select *, extract(min from (log_off-log_on)) as duration
from cte_final 
where log_on is not null;