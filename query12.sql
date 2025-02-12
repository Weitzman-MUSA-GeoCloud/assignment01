/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

-- Result: 17 stations
-- Enter your SQL query here
SELECT COUNT(*) AS num_stations
FROM (
    SELECT
        station_statuses.id AS station_id,
        station_statuses.geog AS station_geog,
        public.ST_Distance(
            public.ST_Transform(station_statuses.geog, 32129),
            public.ST_Transform(public.ST_SetSRID(public.ST_MakePoint(-75.192584, 39.952415), 4326), 32129)
        ) / 1000 AS distance
    FROM
        indego.station_statuses
) AS distances
WHERE distance < 1;
