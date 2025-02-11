/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/
SELECT COUNT(*) AS num_stations
FROM indego.station_statuses
WHERE (
    ROUND(
        ST_DISTANCE(
            indego.station_statuses.geog,
            ST_SETSRID(ST_MAKEPOINT(-75.192584, 39.952415), 4326)::geography
        ) / 50
    ) * 50 < 1000
);




-- Enter your SQL query here
