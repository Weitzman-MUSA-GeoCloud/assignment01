/*
    What is the average distance (rounded to the nearest km) of all stations
    from Meyerson Hall? Your result should have a single record with a single
    column named avg_distance_km.
*/

-- Enter your SQL query here
with merged_trips as (
select 
    id as station_id,
    geog as station_geog,
    round(st_distance(
        geog,
        st_setsrid(st_makepoint(-75.192584, 39.952415), 4326)
    ) /50 ) * 50 as distance
from station_statuses
order by distance
)
select round(avg(distance) /1000) as avg_distance_km
from merged_trips