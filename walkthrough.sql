SELECT fe.location,
       avg(CAST (popularity AS float)) avg_popularity
FROM facebook_employees fe
JOIN facebook_hack_survey f ON f.employee_id = fe.id
GROUP BY fe.location