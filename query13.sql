/*
    Which station is furthest from Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

-- Enter your SQL query here
WITH station_dist AS (
    SELECT
        id AS station_id,
        name AS station_name,
        geog AS station_geog,
        ROUND(
            public.ST_DISTANCE(
                geog,
                public.ST_MAKEPOINT(-75.192584, 39.952415)
            ) / 50
        ) * 50 AS distance
    FROM indego.station_statuses
)
SELECT
    station_id,
    station_name,
    ROUND(AVG(distance) / 50) * 50 AS distance
FROM station_dist
GROUP BY station_id, station_name
ORDER BY distance DESC
LIMIT 1;
