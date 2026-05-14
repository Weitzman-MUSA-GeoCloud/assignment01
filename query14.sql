/*
    Which station is closest to Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

-- Enter your SQL query here
SET search_path TO indego, public;

SELECT
  id AS station_id,
  name AS station_name,
  ROUND(
    ST_Distance(
      ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography,
      ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography
    ) / 50.0
  ) * 50 AS distance
FROM indego_station_status
ORDER BY
  ST_Distance(
    ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography,
    ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography
  ) ASC
LIMIT 1;