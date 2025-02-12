/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
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
),

station_distances as (
    select
        station_id,
        station_geog,
        st_distance(mey_hall.geom, station_geom) as distance
    from stations
    cross join mey_hall
)

select count(station_id) as num_stations
from station_distances
where distance < 1000;
