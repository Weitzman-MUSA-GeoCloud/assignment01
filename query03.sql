/*
    What is the average duration of a trip for 2021?

    Your results should have a single record with a single field named
    `avg_duration`. Round to two decimal places.
*/

SELECT 
    AVG(duration) AS avg_trip_duration_2021
FROM 
    indego.trips_2021_q3;

Result: 18.86 minutes
