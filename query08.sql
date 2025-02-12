/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

-- Enter your SQL query here
with both_years as (
    select
        start_station as station_id,
        station_geog,
        count(*) as station_trips,
        extract(hour from start_time) as hora
    from indego.trips_2021_q3
    group by station_id, hora, station_geog
    union all
    select
        start_station as station_id,
        station_geog,
        count(*) as station_trips,
        extract(hour from start_time) as hora
    from indego.trips_2022_q3
    group by station_id, hora, station_geog
)
select
    station_id,
    station_geog,
    sum(station_trips) as num_trips
from both_years
where hora >= 7 and hora < 10
group by station_id, station_geog
order by num_trips desc limit 5

/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
