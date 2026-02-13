/*
    Using the station status dataset, find the distance in meters of each
    station from Meyerson Hall. Use latitude 39.952415 and longitude -75.192584
    as the coordinates for Meyerson Hall.

    Your results should have three columns: station_id, station_geog, and
    distance. Round to the nearest fifty meters.
*/

-- Enter your SQL query here
SELECT
    s.id AS station_id,
    ST_SetSRID(
        ST_MakePoint(s.longitude, s.latitude),
        4326
    )::geography AS station_geog,
    ROUND(
        ST_Distance(
            ST_SetSRID(
                ST_MakePoint(s.longitude, s.latitude),
                4326
            )::geography,
            ST_SetSRID(
                ST_MakePoint(-75.192584, 39.952415),
                4326
            )::geography
        ) / 50.0
    ) * 50 AS distance
FROM public.indego_station_statuses AS s;






show search_path

SET search_path=PUBLIC

ogr2ogr -f CSV station-statuses.csv indego-station-statuses.geojson -lco GEOMETRY=AS_WKT
ogr2ogr -f "PostgreSQL" -lco "OVERWRITE=YES" PG:"dbname=assignment1 user=postgres password=postgres host=localhost port=5432" assignment1/indego-station-statuses.geojson
C:\Users\kalmanj\AppData\Local\Programs\OSGeo4W\share\proj

setx PROJ_LIB "C:\OSGeo4W\share\proj"
setx PROJ_LIB "C:\Users\kalmanj\AppData\Local\Programs\OSGeo4W\share\proj"