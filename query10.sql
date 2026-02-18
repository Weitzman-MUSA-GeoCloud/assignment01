-- Active: 1769627709257@@127.0.0.1@5432@Assignment-2_MUSA@public
-- Active: 1769627709257@@127.0.0.1@5432@Assignment-2_MUSA@indego
-- Enter your SQL query here
SELECT
    id AS station_id,
    geog AS station_geog,
    ROUND(
        ST_Distance(
            geog,
            ST_SetSRID(
            ST_MakePoint(-75.192584, 39.952415), 
            4326
            ) ::geography
        ) / 50
    ) * 50 AS distance
FROM indego.station_statuses;


SHOW search_path