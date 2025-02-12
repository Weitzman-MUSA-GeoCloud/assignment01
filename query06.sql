/*
    How many trips in each quarter were shorter than 10 minutes?

    Your result should have two records with three columns, one for the year
    (named `trip_year`), one for the quarter (named `trip_quarter`), and one for
    the number of trips (named `num_trips`).
*/

-- Enter your SQL query here

SELECT 
    EXTRACT(YEAR FROM start_time) AS trip_year,
    3 AS trip_quarter,
    COUNT(*) AS num_trips
FROM (
    SELECT start_time, duration FROM indego.trips_2021_q3
    WHERE duration < 10
    UNION ALL
    SELECT start_time, duration FROM indego.trips_2022_q3
    WHERE duration < 10
) AS combined_trips
GROUP BY trip_year
ORDER BY trip_year;

