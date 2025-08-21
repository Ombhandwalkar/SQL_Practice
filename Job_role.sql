USE omi;
drop table if exists job_skills;
create table job_skills
(
	row_id		int,
	job_role	varchar(20),
	skills		varchar(20)
);
insert into job_skills values (1, 'Data Engineer', 'SQL');
insert into job_skills values (2, null, 'Python');
insert into job_skills values (3, null, 'AWS');
insert into job_skills values (4, null, 'Snowflake');
insert into job_skills values (5, null, 'Apache Spark');
insert into job_skills values (6, 'Web Developer', 'Java');
insert into job_skills values (7, null, 'HTML');
insert into job_skills values (8, null, 'CSS');
insert into job_skills values (9, 'Data Scientist', 'Python');
insert into job_skills values (10, null, 'Machine Learning');
insert into job_skills values (11, null, 'Deep Learning');
insert into job_skills values (12, null, 'Tableau');

select * from job_skills;

--- Solution
WITH CTE AS(
SELECT * , SUM(CASE WHEN job_role IS NULL THEN 0 ELSE 1 END) OVER(ORDER BY row_id) AS role_post
FROM job_skills)
SELECT FIRST_VALUE(job_role) OVER(PARTITION BY role_post ORDER BY row_id) AS job, skills
FROM CTE;


--- SOlution 2
WITH RECURSIVE cte AS
(	SELECT row_id,job_role,skills
	FROM job_skills WHERE row_id=1
    UNION
    SELECT js.row_id, COALESCE(js.job_role, cte.job_role) AS job_role, js.skills
	FROM cte
    JOIN job_skills js ON js.row_id = cte.row_id +1)
SELECT * FROM cte
	