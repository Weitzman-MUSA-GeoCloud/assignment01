/*
    What is the average distance (rounded to the nearest km) of all stations
    from Meyerson Hall? Your result should have a single record with a single
    column named avg_distance_km.
*/

-- Enter your SQL query here
with distances as (
    select
        statuses.id as station_id,
        statuses.geog as station_geog,
        round(st_distance(statuses.geog, st_setsrid(st_makepoint(-75.192584, 39.952415), 4326)::geography) / 50) * 50 as distance
    from indego.station_statuses as statuses
)
select
    round(avg(distance) / 1000) as avg_distance_km
from distances;
