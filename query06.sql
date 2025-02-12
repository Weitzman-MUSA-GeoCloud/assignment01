/*
    How many trips in each quarter were shorter than 10 minutes?

    Your result should have two records with three columns, one for the year
    (named `trip_year`), one for the quarter (named `trip_quarter`), and one for
    the number of trips (named `num_trips`).
*/

-- Enter your SQL query here

SELECT 
    2021 AS trip_year, 
    'Q3' AS trip_quarter, 
    COUNT(*) AS num_trips
FROM indego_trips_2021_q3
WHERE duration < 10

UNION ALL

SELECT 
    2022 AS trip_year, 
    'Q3' AS trip_quarter, 
    COUNT(*) AS num_trips
FROM indego_trips_2022_q3
WHERE duration < 10;
