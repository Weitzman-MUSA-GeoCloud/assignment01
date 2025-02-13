/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/
WITH temporary_21_22 AS (
    SELECT
        *,
        ST_MAKEPOINT(start_lon, start_lat)::geography AS geom_point,
        EXTRACT(HOUR FROM start_time) AS day_hour_
    FROM indego.trips_2021_q3
    UNION ALL
    SELECT
        *,
        ST_MAKEPOINT(start_lon, start_lat)::geography AS geom_point,
        EXTRACT(HOUR FROM start_time) AS day_hour_
    FROM indego.trips_2022_q3
)

SELECT
    start_station AS station_id,
    geom_point AS station_geog,
    COUNT(*) AS num_trips
FROM temporary_21_22
WHERE day_hour_ BETWEEN 7 AND 9
GROUP BY station_id, station_geog
ORDER BY num_trips DESC
LIMIT 5;

/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
