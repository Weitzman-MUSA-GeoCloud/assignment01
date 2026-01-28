/*
    What is the average distance (rounded to the nearest km) of all stations
    from Meyerson Hall? Your result should have a single record with a single
    column named avg_distance_km.
*/

SELECT 
    AVG(ST_Distance(geog, ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography)) AS avg_distance_meters
FROM 
    indego.station_statuses
WHERE
    geog IS NOT NULL;
