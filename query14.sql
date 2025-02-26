/*
    Which station is closest to Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

-- Enter your SQL query here
select
    sta.id as station_id,
    sta.name as station_name,
    round(
        st_distance(
            st_setsrid(st_makepoint(-75.192584, 39.952415), 4326)::geography,
            sta.geog
        ) / 50
    ) * 50 as distance
from indego.stations_geo as sta
order by distance asc
limit 1;
