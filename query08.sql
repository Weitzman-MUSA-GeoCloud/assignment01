/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

-- Enter your SQL query here

with all_trips as (
    select
        start_station as station_id,
        count(*) as num_trips
    from indego.trips_2021_q3
    where extract(hour from start_time) >= 7 and extract(hour from start_time) < 10
    group by start_station

    union all

    select
        start_station as station_id,
        count(*) as num_trips
    from indego.trips_2022_q3
    where extract(hour from start_time) >= 7 and extract(hour from start_time) < 10
    group by start_station
)

select
    all_trips.station_id,
    station_statuses.geog as station_geog,
    sum(all_trips.num_trips) as num_trips
from all_trips
left join indego.station_statuses
    on all_trips.station_id::integer = station_statuses.id
group by all_trips.station_id, station_statuses.geog
order by num_trips desc
limit 5;

/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
