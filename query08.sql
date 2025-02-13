/*
    Give the five most popular starting stations acrostation_status all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

-- Enter your SQL query here
SELECT
    combined_trips.start_station AS station_id,
    station_status.geog AS station_geog,
    COUNT(*) AS num_trips
FROM (
    SELECT
        start_station,
        start_time
    FROM indego.trips_2021_q3
    WHERE EXTRACT(HOUR FROM start_time) IN (7, 8, 9)
    UNION ALL
    SELECT
        start_station,
        start_time
    FROM indego.trips_2022_q3
    WHERE EXTRACT(HOUR FROM start_time) IN (7, 8, 9)
) AS combined_trips
INNER JOIN indego.station_statuses AS station_status
    ON CAST(station_status.id AS TEXT) = CAST(combined_trips.start_station AS TEXT)
GROUP BY combined_trips.start_station, station_status.geog
ORDER BY num_trips DESC
LIMIT 5;

/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/


