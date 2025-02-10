/*
    What is the average duration of a trip for 2021?

    Your results should have a single record with a single field named
    `avg_duration`. Round to two decimal places.
*/
-- Result: 18.86 minutes
-- Enter your SQL query here
SELECT CONCAT(CAST(ROUND(AVG(duration), 2) AS TEXT), ' minutes') AS avg_duration
FROM indego.trips_2021_q3;
