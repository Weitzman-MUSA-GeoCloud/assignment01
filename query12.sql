/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

-- Enter your SQL query here
select count(*) as num_stations
from indego.station_statuses
where st_distance(
    st_geogfromtext('SRID=4326;POINT(-75.192584 39.952415)'),
    geog
) < 1000
