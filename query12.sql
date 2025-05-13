/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

-- Enter your SQL query here
WITH within_one AS (
    SELECT 
        id AS station_id, 
        ST_SetSRID(ST_MakePoint(longitude, latitude), 4326) AS station_geog, 
        ST_Distance(
            ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography, 
            ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography
        ) / 1000 AS distance_km
    FROM indego.station_statuses)
SELECT COUNT(*) AS num_stations 
FROM within_one
WHERE distance_km <=1;