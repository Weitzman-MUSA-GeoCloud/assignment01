/*
    List all the passholder types and number of trips for each across all years.

    In other words, in one query, give a list of all `passholder_type` options
    and the number of trips taken by `passholder_type`. Your results should have
    two columns: `passholder_type` and `num_trips`.
*/

-- Enter your SQL query here
WITH combined_data AS (
    SELECT
    passholder_type, 
    COUNT(*) AS num_trips
    FROM indego.trips_2021_q3 GROUP BY passholder_type
    UNION ALL
    SELECT
    passholder_type,
    COUNT(*) AS num_trips
    FROM indego.trips_2022_q3 GROUP BY passholder_type
)
SELECT passholder_type, SUM(num_trips) AS num_trips
FROM combined_data
GROUP BY passholder_type;
