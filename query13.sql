/*
    Which station is furthest from Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

-- Enter your SQL query here

SELECT 
    id AS station_id,
    name AS station_name,
    ROUND(111.111 * SQRT(
        POWER(lat - 39.952415, 2) + 
        POWER((lon - (-75.192584)) * COS(RADIANS(lat)), 2)
    ) * 1000 / 50) * 50 AS distance
FROM indego.station_statuses
ORDER BY distance DESC
LIMIT 1;