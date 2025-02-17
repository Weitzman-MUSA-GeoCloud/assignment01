/*
    Using the station status dataset, find the distance in meters of each
    station from Meyerson Hall. Use latitude 39.952415 and longitude -75.192584
    as the coordinates for Meyerson Hall.

    Your results should have three columns: station_id, station_geog, and
    distance. Round to the nearest fifty meters.
*/

-- Enter your SQL query here
select 
    sta.id as station_id,
    sta.geog as station_geog,
    round(st_distance(
        st_setsrid(st_makepoint(-75.192584,39.952415),4326)::geography,
        sta.geog
    )/50)*50 as distance
from indego.stations_geo as sta
order by distance ASC
limit 5；
