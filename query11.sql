/*
    What is the average distance (rounded to the nearest km) of all stations
    from Meyerson Hall? Your result should have a single record with a single
    column named avg_distance_km.
*/

-- Enter your SQL query here
SELECT 
    ROUND(
        AVG(
            ST_Distance(
                geog::geography,
                ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography
            ) / 1000  -- Convert meters to kilometers
        )
    ) AS avg_distance_km
FROM indego.station_statuses;

# The average distance of all stations from Meyerson Hall is about 3 km. 
