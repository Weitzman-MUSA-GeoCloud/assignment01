/*
    Which station is closest to Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

-- Enter your SQL query here
SELECT id as station_id, name as station_name, ROUND(st_distance(geog, st_makepoint(-75.192584,39.952415)::geography)/50.0)*50.0 AS distance
FROM indego.station_statuses
ORDER BY distance ASC
LIMIT 1;
