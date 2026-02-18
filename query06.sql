/*
    How many trips in each quarter were shorter than 10 minutes?

    Your result should have two records with three columns, one for the year
    (named `trip_year`), one for the quarter (named `trip_quarter`), and one for
    the number of trips (named `num_trips`).
*/

-- Enter your SQL query here

WITH all_trips AS (
    SELECT * FROM indego.trips_2021_q3
    UNION ALL
    SELECT * FROM indego.trips_2022_q3
)

SELECT
    EXTRACT(YEAR FROM start_time)::INTEGER AS trip_year,
    EXTRACT(QUARTER FROM start_time)::INTEGER AS trip_quarter,
    SUM(CASE WHEN duration < 10 THEN 1 ELSE 0 END)::INTEGER AS num_trips
FROM all_trips
GROUP BY trip_year, trip_quarter;
