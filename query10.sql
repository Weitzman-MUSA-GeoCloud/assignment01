/*
    Using the station status dataset, find the distance in meters of each
    station from Meyerson Hall. Use latitude 39.952415 and longitude -75.192584
    as the coordinates for Meyerson Hall.

    Your results should have three columns: station_id, station_geog, and
    distance. Round to the nearest fifty meters.
*/

-- Enter your SQL query here
with mey_hall as (
    select
        st_transform(
            st_setsrid(
                st_makepoint(-75.192584, 39.952415),
                4326
            ),
            32129
        ) as geom --cast to 32129
),

stations as (
    select
        id as station_id,
        geog as station_geog,
        st_transform(geog::geometry, 32129) as station_geom
    from indego.station_statuses
)

select
    stations.station_id,
    stations.station_geog,
    round(st_distance(mey_hall.geom, stations.station_geom) / 50) * 50 as distance
from stations
cross join mey_hall
