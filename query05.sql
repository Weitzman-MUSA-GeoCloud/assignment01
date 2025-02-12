/*
    What is the longest duration trip across the two quarters?

    Your result should have a single row with a single column named max_duration.
*/
SELECT 
    MAX(duration) AS max_duration
FROM 
    indego.trips_2021_q3 t
JOIN 
    indego.trips_2022_q3 t2
ON
    t.duration = t2.duration;

