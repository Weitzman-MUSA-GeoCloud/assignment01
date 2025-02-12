-- Active: 1738184738894@@localhost@5432@assignment01
/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

-- Enter your SQL query here

with combined as (
    select *
    from indego.trips_2021_q3
    union all
    select *
    from indego.trips_2022_q3
)
select
    start_station as station_id,
    station_geog,
    start_time,
    extract(hour from start_time) as start_hour
    -- count trips and name num_trips
from combined;


/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
