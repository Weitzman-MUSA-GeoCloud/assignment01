/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

-- Enter your SQL query here
WITH all_trips AS (
  SELECT start_station, start_time
  FROM indego.trips_2021_q3
  UNION ALL
  SELECT start_station, start_time
  FROM indego.trips_2022_q3
)
SELECT
  ss.id::text AS station_id,
  ss.geog AS station_geog,
  COUNT(*) AS num_trips
FROM all_trips t
JOIN indego.station_statuses ss
  ON ss.id::text = t.start_station
WHERE EXTRACT(HOUR FROM t.start_time) BETWEEN 7 AND 9
GROUP BY ss.id, ss.geog
ORDER BY num_trips DESC
LIMIT 5;



/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
