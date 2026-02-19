/*
    Which station is closest to Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

-- Enter your SQL query here
SELECT
  s.id AS station_id,
  s.name AS station_name,
  (ROUND(
     ST_Distance(
       ST_SetSRID(s.geom, 4326)::geography,
       ST_SetSRID(ST_Point(-75.192584, 39.952415), 4326)::geography
     ) / 50.0
   ) * 50)::int AS distance
FROM indego.station_statuses s
ORDER BY distance ASC
LIMIT 1;
