/*
    What is the average duration of a trip for 2022?

    Your results should have a single record with a single field named
    `avg_duration`. Round to two decimal places.
*/

-- Enter your SQL query here
select ROUND(avg(duration),2) from indego.trips_2022_q3 AS avg_duration;
