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
    indego.stations_staues.id AS station_id,
    indego.stations_staues.geog AS station_geog,
    COUNT(*) AS num_trips
FROM (
    SELECT *
    FROM indego.trips_2021_q3
    WHERE EXTRACT(HOUR FROM start_time) BETWEEN 7 AND 9

    UNION ALL

    SELECT *
    FROM indego.trips_2022_q3
    WHERE EXTRACT(HOUR FROM start_time) BETWEEN 7 AND 9
)
AS combined_trips
INNER JOIN indego.stations_staues
    ON combined_trips.start_station_id = indego.stations_staues.id
GROUP BY station_id, station_geog
ORDER BY num_trips DESC
LIMIT 5;

/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
