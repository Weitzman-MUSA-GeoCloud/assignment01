/*
    Which station is closest to Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

-- Enter your SQL query here

with merged_trips as (
    select
        id as station_id,
        name as station_name,
        round(
            public.st_distance(
                geog,
                public.st_setsrid(public.st_makepoint(-75.192584, 39.952415), 4326)
            ) / 50.0
        ) * 50 as distance
    from station_statuses
)

select
    station_id,
    station_name,
    distance
from merged_trips
order by distance asc
limit 1;
