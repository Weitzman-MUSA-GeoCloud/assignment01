/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

-- Enter your SQL query here

SET search_path TO indego, public;

SELECT
  COUNT(*)::int AS num_stations
FROM indego_station_status
WHERE ST_DWithin(
  ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography,
  ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography,
  1000
);
