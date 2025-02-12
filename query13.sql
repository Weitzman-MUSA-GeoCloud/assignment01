/*
    Which station is furthest from Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

SELECT 
    station_statuses.id AS station_id,
    station_statuses.name AS station_name,
    ROUND(ST_Distance(station_statuses.geog, ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)) / 50) * 50 AS distance
FROM 
    indego.station_statuses
ORDER BY 
    distance DESC
LIMIT 1;
