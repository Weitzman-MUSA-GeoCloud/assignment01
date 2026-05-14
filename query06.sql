/*
    How many trips in each quarter were shorter than 10 minutes?

    Your result should have two records with three columns, one for the year
    (named `trip_year`), one for the quarter (named `trip_quarter`), and one for
    the number of trips (named `num_trips`).
*/

-- Enter your SQL query here

--FIX THIS USE ONLY ONE SELECT STATEMENT

SELECT trip_year, trip_quarter, num_trips
FROM (
    SELECT trip_year, trip_quarter, num_trips FROM count21
    UNION ALL
    SELECT trip_year, trip_quarter, num_trips FROM count22
) AS combined;

