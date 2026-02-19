/*
    What is the longest duration trip across the two quarters?

    Your result should have a single row with a single column named max_duration.
*/

-- Enter your SQL query here
SELECT
  MAX(duration) AS max_duration
FROM (
  SELECT duration FROM indego.trips_2021_q3
  UNION ALL
  SELECT duration FROM indego.trips_2022_q3
) t;


-- how many times the "longest duration" appears
WITH all_trips AS (
  SELECT duration FROM indego.trips_2021_q3
  UNION ALL
  SELECT duration FROM indego.trips_2022_q3
),
mx AS (
  SELECT MAX(duration) AS max_duration FROM all_trips
)
SELECT
  mx.max_duration,
  COUNT(*) AS trips_with_max_duration
FROM all_trips, mx
WHERE all_trips.duration = mx.max_duration
GROUP BY mx.max_duration;
