-- Active: 1769627737941@@127.0.0.1@5432@assignment01
/*
    What is the average distance (rounded to the nearest km) of all stations
    from Meyerson Hall? Your result should have a single record with a single
    column named avg_distance_km.
*/

-- Enter your SQL query here
SELECT
    ROUND(
        (AVG(
            ST_DISTANCE(
                geog,
                ST_MAKEPOINT(-75.192584, 39.952415)::GEOGRAPHY
            )
        ) / 1000)::NUMERIC, 0
    ) AS avg_distance_km
FROM indego.station_statuses;
