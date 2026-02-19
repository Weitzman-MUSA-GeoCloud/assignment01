/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

-- Enter your SQL query here

SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'indego'
  AND table_name = 'station_statuses'
ORDER BY ordinal_position;

WITH all_trips AS (
  SELECT start_station, start_time
  FROM indego.trips_2021_q3
  UNION ALL
  SELECT start_station, start_time
  FROM indego.trips_2022_q3
)
SELECT
  s.id AS station_id,
  ST_SetSRID(s.geom, 4326)::geography AS station_geog,
  COUNT(*) AS num_trips
FROM all_trips t
JOIN indego.station_statuses s
  ON s.id = t.start_station::int
WHERE EXTRACT(HOUR FROM t.start_time) BETWEEN 7 AND 9
GROUP BY s.id, s.geom
ORDER BY num_trips DESC
LIMIT 5;



/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
