/*
    Using the station status dataset, find the distance in meters of each
    station from Meyerson Hall. Use latitude 39.952415 and longitude -75.192584
    as the coordinates for Meyerson Hall.

    Your results should have three columns: station_id, station_geog, and
    distance. Round to the nearest fifty meters.
*/

-- Enter your SQL query here
select
    id as sid,
    geog,
    round(st_distance(
        st_makepoint(-75.192584, 39.952415)::geography,
        geog
    ) / 50) * 50 as dist_m
from indego.station_statuses;