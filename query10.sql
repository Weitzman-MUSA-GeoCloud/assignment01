/*
    Using the station status dataset, find the distance in meters of each
    station from Meyerson Hall. Use latitude 39.952415 and longitude -75.192584
    as the coordinates for Meyerson Hall.

    Your results should have three columns: station_id, station_geog, and
    distance. Round to the nearest fifty meters.
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
    station_statuses.id as station_id,
    station_statuses.geog as station_geog,
    round(
        st_distance(station_statuses.geog, meyerson.meyerson_geog)
        / 50
    ) * 50
    as distance
from indego.station_statuses, meyerson
