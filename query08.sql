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
select
    combined.station_id,
    statuses.geog as station_geog,
    sum(combined.trip_count) as num_trips
from (
    select
        trip21.start_station as station_id,
        extract(hour from trip21.start_time) as start_hour,
        count(trip21.trip_id) as trip_count
    from indego.trips_2021_q3 as trip21
    where extract(hour from trip21.start_time) >= 7 and extract(hour from trip21.start_time) < 10
    group by station_id, start_hour
    union all
    select
        trip22.start_station as station_id,
        extract(hour from trip22.start_time) as start_hour,
        count(trip22.trip_id) as trip_count
    from indego.trips_2022_q3 as trip22
    where extract(hour from trip22.start_time) >= 7 and extract(hour from trip22.start_time) < 10
    group by station_id, start_hour
) as combined
inner join indego.station_statuses as statuses
    on combined.station_id = statuses.id::text
group by combined.station_id, statuses.geog
order by num_trips desc
limit 5;


/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
