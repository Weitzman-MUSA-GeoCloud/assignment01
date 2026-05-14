/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

WITH all_trips AS (
    SELECT
        start_time,
        start_station,
        CASE
            WHEN start_station ~ '^[0-9]+$' THEN start_station::int
        END AS start_station_id,
        lower(trim(start_station)) AS start_station_name
    FROM indego.trips_2021_q3
    UNION ALL
    SELECT
        start_time,
        start_station,
        CASE
            WHEN start_station ~ '^[0-9]+$' THEN start_station::int
        END AS start_station_id,
        lower(trim(start_station)) AS start_station_name
    FROM indego.trips_2022_q3
)

SELECT
    s.id AS station_id,
    s.geog AS station_geog,
    count(*) AS num_trips
FROM all_trips AS t
INNER JOIN indego.station_statuses AS s
    ON (
        (t.start_station_id IS NOT NULL AND t.start_station_id = s.id)
        OR (t.start_station_id IS NULL AND t.start_station_name = lower(trim(s."name")))
    )
WHERE extract(HOUR FROM t.start_time) BETWEEN 7 AND 9
GROUP BY s.id, s.geog
ORDER BY num_trips DESC
LIMIT 5
