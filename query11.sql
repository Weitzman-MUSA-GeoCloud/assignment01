/*
    What is the average distance (rounded to the nearest km) of all stations
    from Meyerson Hall? Your result should have a single record with a single
    column named avg_distance_km.
*/

-- Enter your SQL query here
select round(avg(distance) / 1000) as avg_distance_km
from (
    select
        round(public.st_distance(
            geog,
            public.st_setsrid(public.st_makepoint(-75.192584, 39.952415), 4326)::public.geography
        ) / 50) * 50 as distance
    from indego.station_statuses
    where geog is not null
) as distances;
