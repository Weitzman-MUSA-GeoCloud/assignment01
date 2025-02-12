/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

-- Enter your SQL query here
WITH combined_trips AS (
    SELECT *
    FROM indego.trips_2021_q3
    WHERE EXTRACT(YEAR FROM start_time) = 2021
    UNION ALL
    SELECT *
    FROM indego.trips_2022_q3
    WHERE EXTRACT(YEAR FROM start_time) = 2022
)

SELECT
    trips.start_station AS station_id,
    status.geog AS station_geog,
    COUNT(*) AS num_trips
FROM combined_trips AS trips
INNER JOIN indego.station_statuses AS status
    ON trips.start_station::INTEGER = status.id
WHERE EXTRACT(HOUR FROM trips.start_time) >= 7 AND EXTRACT(HOUR FROM trips.start_time) < 10
GROUP BY station_id, station_geog
ORDER BY num_trips DESC
LIMIT 5;

/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
