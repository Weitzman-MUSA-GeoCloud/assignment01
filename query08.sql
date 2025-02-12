/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

-- Enter your SQL query here
with merged_trips as (
    select 
        start_station, 
        start_lat, 
        start_lon,
        trip_id
    from indego.trips_2021_q3
    where extract(hour from start_time) between 7 and 9

    union all

    select 
        start_station, 
        start_lat, 
        start_lon,
        trip_id
    from indego.trips_2022_q3
    where extract(hour from start_time) between 7 and 9
)
select 
    start_station as station_id,
    st_setsrid(st_nakepoint(start_lon, start_lat), 4326)::geography as station_geog,
    count(trip_id) as num_trips
from merged_trips
group by start_station, station_geog
order by num_trips desc
limit 5;

/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
