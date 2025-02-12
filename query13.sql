/*
    Which station is furthest from Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
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
        name as station_name,
        st_transform(geog::geometry, 32129) as station_geom
    from indego.station_statuses
),

station_distances as (
    select
        stations.station_id,
        stations.station_geog,
        stations.station_name,
        st_distance(mey_hall.geom, stations.station_geom) as distance
    from stations
    cross join mey_hall
),

max_distance as (
    select max(distance) as distance
    from station_distances
)

select
    station_distances.station_id,
    station_distances.station_name,
    round(max_distance.distance / 50) * 50 as distance
from max_distance
left join station_distances on max_distance.distance = station_distances.distance;
