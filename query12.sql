/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

-- Enter your SQL query here

set search_path to public;
select count(*) as num_stations
from indego.stations_geo as sta
where st_dwithin(
    st_setsrid(st_makepoint(-75.192584, 39.952415), 4326)::geography,
    sta.geog,
    1000
);
