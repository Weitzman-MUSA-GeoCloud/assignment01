/*
    What is the average distance (rounded to the nearest km) of all stations
    from Meyerson Hall? Your result should have a single record with a single
    column named avg_distance_km.
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

select round(avg(distance)::numeric, -3) as avg_distance_km
from station_distances
