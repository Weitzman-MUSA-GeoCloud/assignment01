/*
    Which station is closest to Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

-- Enter your SQL query here
with meyh_distances as (
    select
        id as station_id,
        name as station_name,
        round(public.st_distance(
            geog,
            public.st_makepoint(-75.192584, 39.952415)
        ) / 50) * 50 as distance
    from indego.station_statuses
    group by station_id, station_name
)
select *
from meyh_distances
    where distance = (select min(distance) from meyh_distances)
