/*
    Which station is closest to Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

-- Enter your SQL query here
select
    id as sid,
    name as station,
    round(st_distance(
        st_makepoint(-75.192584, 39.952415)::geography,
        geog
    ) / 50) * 50 as dist_m
from indego.station_statuses
order by dist_m
limit 1;