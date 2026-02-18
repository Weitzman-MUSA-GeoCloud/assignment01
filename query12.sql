/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

select 
    count(*) as num_stations
from indego.station_statuses
where public.st_distance(geog, public.st_point(-75.192584, 39.952415)::public.geography) <= 1000
