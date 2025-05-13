/*
    What is the average distance (rounded to the nearest km) of all stations
    from Meyerson Hall? Your result should have a single record with a single
    column named avg_distance_km.
*/

-- Enter your SQL query here
WITH all_distances AS (
    SELECT 
        id AS station_id, 
        ST_SetSRID(ST_MakePoint(longitude, latitude), 4326) AS station_geog, 
        ST_Distance(
            ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography, 
            ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography
        ) / 1000 AS distance_km
    FROM indego.station_statuses
)
SELECT  
    ROUND(AVG(distance_km)) AS avg_distance_km
FROM all_distances;
