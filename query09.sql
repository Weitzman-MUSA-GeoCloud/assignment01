/*
    List all the passholder types and number of trips for each across all years.

    In other words, in one query, give a list of all `passholder_type` options
    and the number of trips taken by `passholder_type`. Your results should have
    two columns: `passholder_type` and `num_trips`.
*/

-- Enter your SQL query here
WITH all_trips AS (
    SELECT passholder_type FROM indego.trips_2021_q3
    UNION ALL
    SELECT passholder_type FROM indego.trips_2022_q3
)
SELECT 
    passholder_type,
    count(*) AS num_trips
FROM all_trips
GROUP BY passholder_type
ORDER BY num_trips DESC;