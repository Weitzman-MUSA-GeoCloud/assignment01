/*
    Which station is furthest from Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/


SELECT
	id AS station_id,
    name AS station_name,
    ROUND((ST_DISTANCE(geog, ST_MAKEPOINT(-75.192584, 39.952415)::geography)) / 50) * 50 AS distance
FROM indego.station_statuses
ORDER BY distance DESC
LIMIT 1;

