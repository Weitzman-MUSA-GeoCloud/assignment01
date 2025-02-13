/*
    List all the passholder types and number of trips for each across all years.

    In other words, in one query, give a list of all `passholder_type` options
    and the number of trips taken by `passholder_type`. Your results should have
    two columns: `passholder_type` and `num_trips`.
*/

-- Enter your SQL query here
SELECT passholder_type, COUNT(*) AS num_trips
FROM (
    SELECT passholder_type FROM indego.trips_2021_q3
    UNION ALL
    SELECT passholder_type FROM indego.trips_2022_q3
) 
GROUP BY passholder_type;