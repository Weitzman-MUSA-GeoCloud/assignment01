/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

with
combined as (
    select
        start_time,
        start_station
    from indego.trips_2022_q3
    union all
    select
        start_time,
        start_station
    from indego.trips_2021_q3
)
select
    combined.start_station as station_id,
    station_statuses.geog as station_geog,
    count(*) as num_trips
from combined
left join indego.station_statuses on combined.start_station = station_statuses.id::text
where extract(hour from combined.start_time) >= 7 and extract(hour from combined.start_time) < 10
group by station_id, station_geog
order by num_trips desc
limit 5;


/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
