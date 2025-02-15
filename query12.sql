/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

-- Enter your SQL query here
SELECT
    SUM(CASE WHEN ST_Distance(geog, ST_MakePoint(-75.192584, 39.952415)) < 1000 THEN 1 ELSE 0 END) AS num_stations
FROM indego.station_statuses;