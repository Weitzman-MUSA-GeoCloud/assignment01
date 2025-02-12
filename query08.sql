/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

-- Enter your SQL query here

SET search_path TO phl, public;

WITH combined_trips AS (
    SELECT 
        start_station AS station_id,
        ST_SetSRID(st_makepoint(start_lon::float, start_lat::float), 4326) AS station_geog,
        COUNT(*) AS num_trips
    FROM (
        SELECT start_station, start_lat, start_lon
        FROM indego_trips_2021_q3
        WHERE EXTRACT(HOUR FROM start_time) BETWEEN 7 AND 9
        UNION ALL
        SELECT start_station, start_lat, start_lon
        FROM indego_trips_2022_q3
        WHERE EXTRACT(HOUR FROM start_time) BETWEEN 7 AND 9
    ) AS all_trips
    GROUP BY start_station, start_lat, start_lon
)
SELECT station_id, station_geog, num_trips
FROM combined_trips
ORDER BY num_trips DESC
LIMIT 5;


/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/


