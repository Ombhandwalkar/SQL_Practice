USE omi;
DROP TABLE IF EXISTS company;
CREATE TABLE company
(
	employee	varchar(10) primary key,
	manager		varchar(10)
);

INSERT INTO company values ('Elon', null);
INSERT INTO company values ('Ira', 'Elon');
INSERT INTO company values ('Bret', 'Elon');
INSERT INTO company values ('Earl', 'Elon');
INSERT INTO company values ('James', 'Ira');
INSERT INTO company values ('Drew', 'Ira');
INSERT INTO company values ('Mark', 'Bret');
INSERT INTO company values ('Phil', 'Mark');
INSERT INTO company values ('Jon', 'Mark');
INSERT INTO company values ('Omid', 'Earl');

SELECT * FROM company;

--- Solution
WITH RECURSIVE cte AS(
		SELECT c.employee, c.manager, c.teams
        FROM company c
        CROSS JOIN cte_teams t
        WHERE c.manager IS NULL
        UNION
        SELECT c.employee, c.manager,
        COALESCE(t.teams, cte.teams) AS teams
        FROM company c
        JOIN cte ON cte.employee = c.employee
        ),
	cte_teams AS (
		SELECT mng.employee, CONCAT('Team' , ROW_NUMBER() OVER( ORDER BY mng.employee))AS teams
		FROM company root
		JOIN company mng 
		ON root.employee=mng.manager
		WHERE root.manager IS NULL)
select teams, string_agg(employee, ', ') as members
from cte 
group by teams
order by teams