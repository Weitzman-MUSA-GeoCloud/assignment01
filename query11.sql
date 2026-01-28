/*
    What is the average distance (rounded to the nearest km) of all stations
    from Meyerson Hall? Use latitude 39.952415 and longitude -75.192584 Your result should have a single record with a single
    column named avg_distance_km.
*/

-- Enter your SQL query here
SELECT 
    ROUND(
        AVG(
            ST_Distance(
                ST_MakePoint(start_lon, start_lat)::geography,
                ST_MakePoint(-75.192584, 39.952415)::geography
            )
        ) / 1000
    ) AS avg_distance_km
FROM (
    SELECT DISTINCT start_lat, start_lon
    FROM indego.trips_2021_q3
    WHERE start_lat IS NOT NULL AND start_lon IS NOT NULL
    UNION
    SELECT DISTINCT start_lat, start_lon
    FROM indego.trips_2022_q3
    WHERE start_lat IS NOT NULL AND start_lon IS NOT NULL
) AS stations;

