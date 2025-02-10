/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

-- Result: 3032, 3102, 3012, 3066, 3007
-- Enter your SQL query here
SELECT
    combined_trips.start_station AS station_id,
    ss.geog AS station_geog,
    COUNT(*) AS num_trips
FROM (
    SELECT start_station, start_time FROM indego.trips_2021_q3
    WHERE EXTRACT(HOUR FROM start_time) IN (7, 8, 9)
    UNION ALL
    SELECT start_station, start_time FROM indego.trips_2022_q3
    WHERE EXTRACT(HOUR FROM start_time) IN (7, 8, 9)
) AS combined_trips
INNER JOIN indego.station_statuses AS ss
    ON CAST(ss.id AS TEXT) = CAST(combined_trips.start_station AS TEXT)
GROUP BY combined_trips.start_station, ss.geog
ORDER BY num_trips DESC
LIMIT 5;
