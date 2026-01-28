/*
    How many trips in each quarter were shorter than 10 minutes?

    Your result should have two records with three columns, one for the year
    (named `trip_year`), one for the quarter (named `trip_quarter`), and one for
    the number of trips (named `num_trips`).
*/

-- Enter your SQL query here
SELECT
    EXTRACT(YEAR FROM start_time) AS trip_year, -- dynamic query to get year from date
    EXTRACT(QUARTER FROM start_time) AS trip_quarter,-- dynamic query to get quarter from date
    COUNT(DISTINCT trip_id) AS num_trips
FROM indego.trips_2021_q3
WHERE duration < 10
GROUP BY EXTRACT(YEAR FROM start_time), EXTRACT(QUARTER FROM start_time)


UNION

SELECT
    EXTRACT(YEAR FROM start_time) AS trip_year,
    EXTRACT(QUARTER FROM start_time) AS trip_quarter,
    COUNT(DISTINCT trip_id) AS num_trips
FROM indego.trips_2022_q3
WHERE duration < 10
GROUP BY EXTRACT(YEAR FROM start_time), EXTRACT(QUARTER FROM start_time);
