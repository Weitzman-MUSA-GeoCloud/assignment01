/*
    What is the average distance (rounded to the nearest km) of all stations
    from Meyerson Hall? Your result should have a single record with a single
    column named avg_distance_km.
*/
SELECT
    id AS station_id,
    geog AS station_geog,
    ROUND(
        ST_DISTANCE(geog, ST_SETSRID(ST_MAKEPOINT(-75.192584, 39.952415), 4326))
        / 50
    )
    * 50 AS distance
FROM
    indego.station_statuses
ORDER BY
    distance;
