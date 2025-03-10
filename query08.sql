/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

-- Enter your SQL query here

set search_path to public;
select
    sta.id as station_id,
    sta.geog as station_geog,
    count(*) as num_trips
from (
    select
        start_time,
        start_station
    from indego.trips_2021_q3
    union all
    select
        start_time,
        start_station
    from indego.trips_2022_q3
) as trips
right join indego.stations_geo as sta
    on trips.start_station = cast(sta.id as text)
where cast((extract(hour from start_time)) as integer) between 7 and 9
group by sta.id, sta.geog
order by num_trips desc
limit 5;

/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
