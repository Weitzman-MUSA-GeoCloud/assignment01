/*
    Which station is furthest from Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

SELECT
    indego.station_statuses.id AS station_id,
    indego.station_statuses.name AS station_name,
    ROUND(ST_DISTANCE(indego.station_statuses.geog, ST_MAKEPOINT(-75.192584, 39.952415)::geography) / 50) * 50 AS distance
FROM indego.station_statuses
ORDER BY distance DESC
LIMIT 1;
