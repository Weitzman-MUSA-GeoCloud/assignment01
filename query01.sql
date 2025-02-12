-- Active: 1738783914188@@localhost@5432@assignment01@indego
-- Active: 1738783914188@@localhost@5432
/*
    Example: How many bike trips in Q3 2021. Name the resulting column
    num_trips.
*/

-- Enter your SQL query here
select count(*) as num_trips
from indego.trips_2021_q3
