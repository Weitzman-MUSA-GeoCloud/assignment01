/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

-- Enter your SQL query here
SELECT
  COUNT(*) AS num_stations
FROM indego.station_statuses s
WHERE ST_Distance(
        ST_SetSRID(s.geom, 4326)::geography,
        ST_SetSRID(ST_Point(-75.192584, 39.952415), 4326)::geography
      ) <= 1000;

