/*
    Using the station status dataset, find the distance in meters of each
    station from Meyerson Hall. Use latitude 39.952415 and longitude -75.192584
    as the coordinates for Meyerson Hall.

    Your results should have three columns: station_id, station_geog, and
    distance. Round to the nearest fifty meters.
*/

-- Enter your SQL query here
-- Appending public. in front of functions because the PostGIS extension uses public schema
SELECT
    id AS station_id,
    geog AS station_geog,
    ROUND(
        public.ST_DISTANCE(
            geog,
            public.ST_MAKEPOINT(-75.192584, 39.952415)
        ) / 50
    ) * 50 AS distance
FROM indego.indego_station_statuses;
