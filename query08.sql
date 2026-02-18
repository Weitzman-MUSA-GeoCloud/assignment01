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
  SELECT
    start_time,
    start_station,
    CASE
      WHEN start_station ~ '^[0-9]+$' THEN start_station::int
      ELSE NULL
    END AS start_station_id,
    LOWER(TRIM(start_station)) AS start_station_name
  FROM indego.trips_2021_q3

  UNION ALL

  SELECT
    start_time,
    start_station,
    CASE
      WHEN start_station ~ '^[0-9]+$' THEN start_station::int
      ELSE NULL
    END AS start_station_id,
    LOWER(TRIM(start_station)) AS start_station_name
  FROM indego.trips_2022_q3
)
SELECT
  s.id AS station_id,
  s.geog AS station_geog,
  COUNT(*) AS num_trips
FROM all_trips t
JOIN indego.station_statuses s
  ON (
    (t.start_station_id IS NOT NULL AND s.id = t.start_station_id)
    OR
    (t.start_station_id IS NULL AND LOWER(TRIM(s.name)) = t.start_station_name)
  )
WHERE EXTRACT(HOUR FROM t.start_time) BETWEEN 7 AND 9
GROUP BY s.id, s.geog
ORDER BY num_trips DESC
LIMIT 5;

/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
