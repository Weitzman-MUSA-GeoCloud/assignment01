-- Active: 1769627737941@@127.0.0.1@5432@assignment01@public
/*
    Using the station status dataset, find the distance in meters of each
    station from Meyerson Hall. Use latitude 39.952415 and longitude -75.192584
    as the coordinates for Meyerson Hall.

    Your results should have three columns: station_id, station_geog, and
    distance. Round to the nearest fifty meters.
*/

-- Enter your SQL query here
SELECT
    id AS station_id,
    geog AS station_geog,
    ROUND(
        (ST_DISTANCE(
            geog,
            ST_MAKEPOINT(-75.192584, 39.952415)::GEOGRAPHY
        ) / 50)
    ) * 50 AS distance
FROM indego.station_statuses;
