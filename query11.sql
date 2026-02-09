/*
    What is the average distance (rounded to the nearest km) of all stations
    from Meyerson Hall? Your result should have a single record with a single
    column named avg_distance_km.
*/

-- Enter your SQL query here
WITH origin AS (
  SELECT ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography AS g
)
SELECT
  ROUND(AVG(ST_Distance(s.geog, o.g)) / 1000.0)::int AS avg_distance_km
FROM indego.station_statuses s
CROSS JOIN origin o;


