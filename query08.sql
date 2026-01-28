/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

-- Enter your SQL query here
WITH morning_counts AS (
    -- Q3 2021 morning counts per station
    SELECT
        start_station::INT AS station_id,
        COUNT(*) AS trips
    FROM indego.trips_2021_q3
    WHERE EXTRACT(HOUR FROM start_time) BETWEEN 7 AND 9
    GROUP BY station_id

    UNION ALL

    -- Q3 2022 morning counts per station
    SELECT
        start_station::INT AS station_id,
        COUNT(*) AS trips
    FROM indego.trips_2022_q3
    WHERE EXTRACT(HOUR FROM start_time) BETWEEN 7 AND 9
    GROUP BY station_id
)

SELECT
    s.id AS station_id,
    s.geog AS station_geog,
    SUM(mc.trips) AS num_trips
FROM morning_counts AS mc
INNER JOIN indego.station_statuses AS s
    ON mc.station_id = s.id
GROUP BY s.id, s.geog
ORDER BY num_trips DESC
LIMIT 5;


/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
