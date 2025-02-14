/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
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
    count(*) as num_stations
from distances
where distance <= 1000;