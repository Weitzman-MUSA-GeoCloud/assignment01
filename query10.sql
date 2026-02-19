/*
    Using the station status dataset, find the distance in meters of each
    station from Meyerson Hall. Use latitude 39.952415 and longitude -75.192584
    as the coordinates for Meyerson Hall.

    Your results should have three columns: station_id, station_geog, and
    distance. Round to the nearest fifty meters.
*/

-- Enter your SQL query here
SELECT
  s.id AS station_id,
  ST_SetSRID(s.geom, 4326)::geography AS station_geog,
  (ROUND(
     ST_Distance(
       ST_SetSRID(s.geom, 4326)::geography,
       ST_SetSRID(ST_Point(-75.192584, 39.952415), 4326)::geography
     ) / 50.0
   ) * 50)::int AS distance
FROM indego.station_statuses s;
