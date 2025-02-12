/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

WITH temporary_21_22 AS(
	SELECT *,
	ST_MakePoint(trips_2021_q3.start_lon,trips_2021_q3.start_lat)::geography,
	EXTRACT(HOUR FROM trips_2021_q3.start_time) AS day_hour
	FROM indego.trips_2021_q3 AS trips_2021_q3
	UNION ALL
	SELECT *,
	ST_MakePoint(trips_2022_q3.start_lon,trips_2022_q3.start_lat)::geography,
	EXTRACT(HOUR FROM trips_2022_q3.start_time) AS day_hour
	FROM indego.trips_2022_q3 AS trips_2022_q3
)
SELECT COUNT(*) AS num_trips,
start_station AS station_id,
st_makepoint AS station_geog
FROM temporary_21_22
WHERE day_hour BETWEEN 7 AND 9
GROUP BY station_id, station_geog
ORDER by num_trips DESC
LIMIT 5;


/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
