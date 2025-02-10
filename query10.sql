/*
    Using the station status dataset, find the distance in meters of each
    station from Meyerson Hall. Use latitude 39.952415 and longitude -75.192584
    as the coordinates for Meyerson Hall.

    Your results should have three columns: station_id, station_geog, and
    distance. Round to the nearest fifty meters.
*/

-- Result: Nearest stations to Meyerson Hall are 3208, 3207, 3029, 3009 and 3020.
-- Enter your SQL query here
SELECT
    station_statuses.id AS station_id,
    station_statuses.geog AS station_geog,
    ROUND(
        public.ST_Distance(
            public.ST_Transform(station_statuses.geog, 32129),
            public.ST_Transform(public.ST_SetSRID(public.ST_MakePoint(-75.192584, 39.952415), 4326), 32129)
        ) / 50.0
    ) * 50 AS distance
FROM indego.station_statuses
ORDER BY distance ASC;
