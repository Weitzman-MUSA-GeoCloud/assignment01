/*
    What is the average distance (rounded to the nearest km) of all stations
    from Meyerson Hall? Your result should have a single record with a single
    column named avg_distance_km.
*/

SELECT 
    ROUND(AVG(ST_Distance(geog, ST_MakePoint(-75.192584, 39.952415)::geography)) / 1000) AS avg_distance_km
FROM indego.station_statuses;
