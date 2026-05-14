/*
    Which station is closest to Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

select 
    id as station_id,
    name as station_name,
    round(public.st_distance(geog, public.st_point(-75.192584, 39.952415)::public.geography)::numeric / 50) * 50 as distance
from indego.station_statuses
order by distance asc
limit 1
