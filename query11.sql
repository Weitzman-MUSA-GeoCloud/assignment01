/*
    What is the average distance (rounded to the nearest km) of all stations
    from Meyerson Hall? Your result should have a single record with a single
    column named avg_distance_km.
*/

-- Enter your SQL query here
SELECT 
    ROUND(AVG(
        111.111 * SQRT(
            POWER(lat - 39.952415, 2) + 
            POWER((lon - (-75.192584)) * COS(RADIANS(lat)), 2)
        )
    )) AS avg_distance_km
FROM indego.station_statuses;