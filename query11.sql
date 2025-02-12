/*
    What is the average distance (rounded to the nearest km) of all stations
    from Meyerson Hall? Your result should have a single record with a single
    column named avg_distance_km.
*/

-- Enter your SQL query here
WITH station_dist AS (
    SELECT
        id AS station_id,
        geog AS station_geog,
        ROUND(
            public.ST_DISTANCE(
                geog,
                public.ST_MAKEPOINT(-75.192584, 39.952415)
            ) / 50
        ) * 50 AS distance
    FROM indego.station_statuses
)
SELECT ROUND(AVG(distance) / 1000) AS avg_distance_km
FROM station_dist;
