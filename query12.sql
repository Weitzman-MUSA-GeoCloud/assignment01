/*
    How many stations are within 1km of Meyerson Hall? Use latitude 39.952415 and longitude -75.192584

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

-- Enter your SQL query here

SELECT COUNT(*) AS num_stations
FROM (
    SELECT DISTINCT start_lat, start_lon
    FROM indego.trips_2021_q3
    WHERE start_lat IS NOT NULL AND start_lon IS NOT NULL
    UNION
    SELECT DISTINCT start_lat, start_lon
    FROM indego.trips_2022_q3
    WHERE start_lat IS NOT NULL AND start_lon IS NOT NULL
) AS stations
WHERE ST_Distance(
    ST_MakePoint(start_lon, start_lat)::geography,
    ST_MakePoint(-75.192584, 39.952415)::geography
) <= 1000;
