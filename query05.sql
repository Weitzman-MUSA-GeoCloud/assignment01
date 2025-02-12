/*
    What is the longest duration trip across the two quarters?

    Your result should have a single row with a single column named max_duration.
*/

-- Enter your SQL query here
WITH combi AS (
    SELECT MAX(duration) AS duration
    FROM indego.trips_2021_q3
    UNION -- UNION removes duplicate values by default
    SELECT MAX(duration) AS duration
    FROM indego.trips_2022_q3
)

SELECT MAX(duration) AS max_duration -- not needed here because the max is 1440 for both, but just in case
FROM combi;
