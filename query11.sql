/*
    What is the average distance (rounded to the nearest km) of all stations
    from Meyerson Hall? Your result should have a single record with a single
    column named avg_distance_km.
*/

-- Enter your SQL query here
SELECT 
    ROUND(AVG(ST_Distance(
        ST_Transform(indego.station_statuses.geog::geometry, 32129),
        ST_Transform(public.ST_SetSRID(public.ST_MakePoint(-75.192584, 39.952415), 4326), 32129) 
    )) / 1000) AS avg_distance_km
FROM indego.station_statuses;
