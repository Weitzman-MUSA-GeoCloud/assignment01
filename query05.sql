/*
    What is the longest duration trip across the two quarters?

    Your result should have a single row with a single column named max_duration.
*/

-- Enter your SQL query here
SELECT GREATEST(
    (SELECT MAX(duration) FROM indego.trips_2021_q3),
    (SELECT MAX(duration) FROM indego.trips_2022_q3)
) AS max_duration