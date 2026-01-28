WITH all_trips AS (
    SELECT passholder_type
    FROM indego.trips_2021_q3

    UNION ALL

    SELECT passholder_type
    FROM indego.trips_2022_q3
)

SELECT
    passholder_type,
    COUNT(*) AS num_trips
FROM all_trips
GROUP BY passholder_type
ORDER BY num_trips DESC;
