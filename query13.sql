/*
    Which station is furthest from Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

-- Enter your SQL query here
with meyh as (
    select
        id as station_id,
        name as station_name,
        round((public.st_distance(
            geog,
            public.st_makepoint(-75.192584, 39.952415)
        ) / 50::numeric)) * 50 as base_dist
    from
        indego.station_statuses
    group by station_id, station_name
)
select
    station_id,
    station_name,
    base_dist as distance
from (
    select
        *,
        max(base_dist) over () as distance
    from meyh
) as meyh_d
where base_dist = distance
