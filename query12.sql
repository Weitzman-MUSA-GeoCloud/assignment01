/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

with
meyerson as (
    select
        st_setsrid(
            st_makepoint(-75.192584, 39.952415),
            4326
        ) as meyerson_geog
)
select
    count(*) as num_stations
from indego.station_statuses, meyerson
where st_distance(station_statuses.geog, meyerson.meyerson_geog) < 1000
