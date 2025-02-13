/*
    What is the average duration of a trip for 2022?

    Your results should have a single record with a single field named
    `avg_duration`. Round to two decimal places.
*/

-- Enter your SQL query here
SELECT Round(AVG(duration), 2) AS avg_duration
FROM indego.trips_2022_q3;