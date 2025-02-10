/*
    Example: How many bike trips in Q3 2021. Name the resulting column
    num_trips.
*/

-- Own note: database `assignment01` was created for this assignment, along with the `indego
-- Result: 300,432
-- Enter your SQL query here
SELECT count(*) AS num_trips
FROM indego.trips_2021_q3;
