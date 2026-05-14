/*
    What is the average distance (rounded to the nearest km) of all stations
    from Meyerson Hall? Your result should have a single record with a single
    column named avg_distance_km.
*/

-- Enter your SQL query here
SELECT round(avg(st_distance(geog, st_setsrid(st_makepoint(-75.192584, 39.952415), 4326)::geography)) / 1000) AS avg_distance_km
FROM indego.station_statuses;
