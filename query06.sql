/*
    How many trips in each quarter were shorter than 10 minutes?

    Your result should have two records with three columns, one for the year
    (named `trip_year`), one for the quarter (named `trip_quarter`), and one for
    the number of trips (named `num_trips`).
*/

-- Enter your SQL query here
SELECT 
    CASE 
        WHEN source_table = '2021' THEN 2021
        WHEN source_table = '2022' THEN 2022
    END AS trip_year,
    'Q3' AS trip_quarter,
    COUNT(*) AS num_trips
FROM (
    SELECT duration, '2021' AS source_table FROM indego.trips_2021_q3
    UNION ALL
    SELECT duration, '2022' AS source_table FROM indego.trips_2022_q3
) AS combined_trips
WHERE duration < 10
GROUP BY trip_year, trip_quarter
ORDER BY trip_year;