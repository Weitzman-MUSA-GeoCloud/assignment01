-- Active: 1738786470365@@127.0.0.1@5432@Assignment01@indego
/*
    Using the station status dataset, find the distance in meters of each
    station from Meyerson Hall. Use latitude 39.952415 and longitude -75.192584
    as the coordinates for Meyerson Hall.

    Your results should have three columns: station_id, station_geog, and
    distance. Round to the nearest fifty meters.
*/

-- Enter your SQL query here

SELECT 
    id, 
    geog, 
    ROUND(ST_Distance(
        geog, 
        ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography
    ) / 50) * 50 AS distance
FROM indego.station_statuses
WHERE geog IS NOT NULL
ORDER BY distance ASC;