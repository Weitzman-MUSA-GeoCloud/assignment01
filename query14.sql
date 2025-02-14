/*
    Which station is closest to Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

-- Enter your SQL query here
with distances as (
    select
        statuses.id as station_id,
        statuses.geog as station_geog,
        statuses.name as station_name,
        round(st_distance(statuses.geog, st_setsrid(st_makepoint(-75.192584, 39.952415), 4326)::geography) / 50) * 50 as distance
    from indego.station_statuses as statuses
)
select
    station_id,
    station_name,
    distance
from distances
order by distance
limit 1;
