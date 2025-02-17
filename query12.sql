/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

-- Enter your SQL query here
with station_dist as (
    select
        public.st_distance(
            geog,
            public.st_makepoint(-75.192584, 39.952415)
        ) / 1000 as distance
    from indego.station_statuses
)

select count(*) as num_stations
from station_dist
where distance <= 1
