-- Active: 1769627356538@@172.31.112.109@5432@postgres@indego
/*
    What is the average duration of a trip for 2021?

    Your results should have a single record with a single field named
    `avg_duration`. Round to two decimal places.
*/

-- Enter your SQL query here
SELECT ROUND(AVG(duration), 2) AS avg_duration
FROM trips_2021_q3;


