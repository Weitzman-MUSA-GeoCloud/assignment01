/*
    How many trips in each quarter were shorter than 10 minutes?

    Your result should have two records with three columns, one for the year
    (named `trip_year`), one for the quarter (named `trip_quarter`), and one for
    the number of trips (named `num_trips`).
*/
-- Result: 2021 Q3: 124528 trips; 2022 Q3: 137372 trips
-- Enter your SQL query here
SELECT
    (SELECT COUNT(*) FROM indego.trips_2021_q3 WHERE duration < 10) AS short_trips_21q3,
    (SELECT COUNT(*) FROM indego.trips_2022_q3 WHERE duration < 10) AS short_trips_22q3;
