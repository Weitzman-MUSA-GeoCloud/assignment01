/*
    How many trips in each quarter were shorter than 10 minutes?

    Your result should have two records with three columns, one for the year
    (named `trip_year`), one for the quarter (named `trip_quarter`), and one for
    the number of trips (named `num_trips`).
*/

WITH temporary_trips AS (
    SELECT
        COUNT(*) AS num_trips,
        2021 AS trip_year,
        '3' AS trip_quarter
    FROM indego.trips_2021_q3
    WHERE duration < 10
    UNION
    SELECT
        COUNT(*) AS num_trips,
        2022 AS trip_year,
        '3' AS trip_quarter
    FROM indego.trips_2022_q3
    WHERE duration < 10
)

SELECT *
FROM temporary_trips
