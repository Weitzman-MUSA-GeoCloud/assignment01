/*
    Using the station status dataset, find the distance in meters of each
    station from Meyerson Hall. Use latitude 39.952415 and longitude -75.192584
    as the coordinates for Meyerson Hall.

    Your results should have three columns: station_id, station_geog, and
    distance. Round to the nearest fifty meters.
*/

-- Enter your SQL query here


SELECT
    s.id as station_id,
    s.geog as station_geog,
    round(
        st_distance(
        s.geog,
        st_setsrid(st_makepoint(-75.192584, 39.952415), 4326)::geography,
        TRUE
         )/50
    )*50 AS distance
FROM indego.station_statuses AS s
ORDER BY station_id;



