/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

-- Enter your SQL query here

WITH n AS (SELECT 
    station_id,
    COUNT(*) AS num_trips
FROM (
    SELECT start_station AS station_id,
           start_time
    FROM indego.trips_2021_q3
    WHERE EXTRACT(HOUR FROM start_time) BETWEEN 7 AND 9

    UNION ALL

    SELECT start_station AS station_id,
           start_time
    FROM indego.trips_2022_q3
    WHERE EXTRACT(HOUR FROM start_time) BETWEEN 7 AND 9
)
GROUP BY station_id)
SELECT n.station_id,
       geog AS station_geog,
       n.num_trips
FROM n
LEFT JOIN indego.stations
    ON id = n.station_id::numeric
ORDER BY n.num_trips DESC
LIMIT 5;

/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
