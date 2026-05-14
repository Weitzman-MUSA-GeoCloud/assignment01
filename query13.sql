/*
    Which station is furthest from Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

-- Enter your SQL query here
WITH origin AS (
  SELECT ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography AS g
),
dist AS (
  SELECT
    s.id AS station_id,
    s.name AS station_name,
    (ROUND(ST_Distance(s.geog, o.g) / 50.0) * 50)::int AS distance
  FROM indego.station_statuses s
  CROSS JOIN origin o
)
SELECT
  station_id,
  station_name,
  distance
FROM dist
ORDER BY distance DESC, station_id
LIMIT 1;
