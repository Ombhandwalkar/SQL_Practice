USE omi;

--- Problem Statement:
--- Given a list of matches in the group stage of the football World Cup, compute the number of points each team currently has.
--- You are given two tables, “teams” and “matches”, with the following structures:



DROP TABLE IF EXISTS teams;
CREATE TABLE teams 
(
       team_id       INT PRIMARY KEY,
       team_name     VARCHAR(50) NOT NULL
);


DROP TABLE IF EXISTS matches;
CREATE TABLE matches 
(
       match_id 	INT PRIMARY KEY,
       host_team 	INT,
       guest_team 	INT,
       host_goals 	INT,
       guest_goals 	INT
);

INSERT INTO teams VALUES(10, 'Give');
INSERT INTO teams VALUES(20, 'Never');
INSERT INTO teams VALUES(30, 'You');
INSERT INTO teams VALUES(40, 'Up');
INSERT INTO teams VALUES(50, 'Gonna');

INSERT INTO matches VALUES(1, 30, 20, 1, 0);
INSERT INTO matches VALUES(2, 10, 20, 1, 2);
INSERT INTO matches VALUES(3, 20, 50, 2, 2);
INSERT INTO matches VALUES(4, 10, 30, 1, 0);
INSERT INTO matches VALUES(5, 30, 50, 0, 1);


SELECT * FROM teams;
SELECT * FROM matches;

--- Solution
WITH cte AS(
			SELECT * ,
				CASE WHEN host_goals > guest_goals THEN 3
					 WHEN host_goals < guest_goals THEN 0
					 ELSE 1  END AS host_score,
				CASE WHEN guest_goals > host_goals THEN 3
					 WHEN guest_goals < host_goals THEN 0
					 ELSE 1 END AS guest_score   
			FROM matches),
    
	 host AS(
			SELECT host_team, SUM(host_score) AS total_host_score
            FROM cte
            GROUP BY host_team),
            
	 guest AS(
			SELECT guest_team, SUM(guest_score) AS total_guest_score
            FROM cte
            GROUP BY guest_team)
            
SELECT COALESCE(host_team,guest_team,t.team_id) AS team, t.team_name,
	   COALESCE(total_host_score,0) + COALESCE(total_guest_score,0) AS num_points
FROM host h
JOIN guest g ON g.guest_team=h.host_team
RIGHT JOIN teams t ON t.team_id= COALESCE(host_team,guest_team)
ORDER BY num_points DESC, team;