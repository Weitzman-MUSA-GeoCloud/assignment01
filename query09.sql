/*
    List all the passholder types and number of trips for each across all years.

    In other words, in one query, give a list of all `passholder_type` options
    and the number of trips taken by `passholder_type`. Your results should have
    two columns: `passholder_type` and `num_trips`.
*/

-- Enter your SQL query here

SELECT passholder, SUM(num_trips) AS num_trips
FROM (
    SELECT passholder, COUNT(*) AS num_trips FROM indego_trips_2021_q3 GROUP BY passholder
    UNION ALL
    SELECT passholder, COUNT(*) AS num_trips FROM indego_trips_2022_q3 GROUP BY passholder
) COMBINED
GROUP BY passholder
ORDER BY num_trips DESC;

    