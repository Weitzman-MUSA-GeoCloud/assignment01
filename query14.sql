/*
    Which station is closest to Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

-- Enter your SQL query here

WITH n AS (
SELECT 
    id AS station_id,
    name AS station_name,
    ((
        public.ST_Distance(
            geog,
            public.ST_MakePoint(-75.192584, 39.952415)
            )
        ::numeric)) AS distance_to_round
FROM indego.stations
)
SELECT
  station_id,
  station_name,
  (ROUND(distance_to_round / 50) * 50)::numeric AS distance
FROM n
ORDER BY distance_to_round ASC
LIMIT 1;
