/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

-- Enter your SQL query here
SELECT
    trips.start_station AS station_id,
    station_status.geog AS station_geog,
    COUNT(*) AS num_trips
FROM (

    SELECT
        t1.start_station AS start_station,
        t1.start_time AS start_time
    FROM indego.trips_2021_q3 AS t1
    UNION ALL
    SELECT
        t2.start_station AS start_station,
        t2.start_time AS start_time
    FROM indego.trips_2022_q3 AS t2
) AS trips

LEFT JOIN indego.station_statuses AS station_status
    ON station_status.id = trips.start_station::INTEGER

WHERE EXTRACT(HOUR FROM trips.start_time) BETWEEN 7 AND 9
GROUP BY trips.start_station, station_status.geog
ORDER BY num_trips DESC
LIMIT 5;
/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
