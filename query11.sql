/*
    What is the average distance (rounded to the nearest km) of all stations
    from Meyerson Hall? Your result should have a single record with a single
    column named avg_distance_km.
*/

with
distances as (
    with
    meyerson as (
        select
            st_setsrid(
                st_makepoint(-75.192584, 39.952415),
                4326
            ) as meyerson_geog
    )
    select
        station_statuses.id as station_id,
        station_statuses.geog as station_geog,
        st_distance(station_statuses.geog, meyerson.meyerson_geog) as distance
    from indego.station_statuses, meyerson
)
select 
    round(avg(distance)::decimal / 1000, 0) as avg_distance_km
from distances;
