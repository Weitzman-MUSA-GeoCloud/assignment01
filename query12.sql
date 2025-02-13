/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

-- Enter your SQL query here

with merged_trips as (
    select
        id as station_id,
        public.st_distance(
            geog,
            public.st_setsrid(public.st_makepoint(-75.192584, 39.952415), 4326)
        ) as distance
    from public.station_statuses
)

select count(*) as num_stations
from merged_trips
where distance < 1000;
