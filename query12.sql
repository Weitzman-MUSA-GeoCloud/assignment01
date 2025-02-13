/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

WITH temporary_table AS (
    SELECT
        id AS station_id,
        (ST_DISTANCE(geog, ST_MAKEPOINT(-75.192584, 39.952415)::geography)) AS distance
    FROM indego.station_statuses
)

SELECT COUNT(*) AS num_stations
FROM temporary_table
WHERE distance < 1000;
