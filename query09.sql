/*
    List all the passholder types and number of trips for each across all years.

    In other words, in one query, give a list of all `passholder_type` options
    and the number of trips taken by `passholder_type`. Your results should have
    two columns: `passholder_type` and `num_trips`.
*/

SELECT
    passholder_type,
    COUNT(*) AS num_trips
FROM (
    SELECT passholder_type FROM indego.trips_2021_q3
    UNION ALL
    SELECT passholder_type FROM indego.trips_2022_q3
) AS t
GROUP BY passholder_type;

Result: There are three passholder types. 
1. Day Pass - 61,659
2. Indego30 - 441,856
3. Indego365 - 109,251

However, 43 were coded as NULL and 2 were coded as Walk-up.

