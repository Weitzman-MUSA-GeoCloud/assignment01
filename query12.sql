/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

-- Enter your SQL query here
WITH origin AS (
  SELECT ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography AS g
)
SELECT
  COUNT(*)::int AS num_stations
FROM indego.station_statuses s
CROSS JOIN origin o
WHERE ST_DWithin(s.geog, o.g, 1000);
