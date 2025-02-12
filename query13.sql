/*
    Which station is furthest from Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

-- Enter your SQL query here

SET search_path TO phl, public;

SELECT 
    id AS station_id, 
    name AS station_name, 
    ROUND(ST_Distance(
        phlstations.geog, 
        ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography
    ) / 50) * 50 AS distance
FROM phlstations
ORDER BY ST_Distance(
    phlstations.geog, 
    ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography
) DESC
LIMIT 1;
