/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

-- Enter your SQL query here
select count(*) as num_stations
from indego.station_statuses
where
    geog is not null
    and public.st_distance(
        geog,
        public.st_setsrid(public.st_makepoint(-75.192584, 39.952415), 4326)::public.geography
    ) <= 1000;
