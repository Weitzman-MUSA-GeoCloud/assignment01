/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

-- Enter your SQL query here
select 
    count(*) as num_stations
from indego.stations_geo
where st_distance(geog, st_point(-75.192584, 39.952415)::geography) <= 1000
