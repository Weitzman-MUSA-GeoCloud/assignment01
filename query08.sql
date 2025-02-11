/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

-- Enter your SQL query here
with stations as (
    select
        id::text as station_id,
        geog as station_geog
    from indego.station_statuses
)

select
    station_id,
    station_geog,
    count(*) as num_trips
from (
    select start_station as station_id
    from indego.trips_2021_q3
    where
        extract(hour from start_time) >= 7
        and extract(hour from start_time) < 10
    union all
    select start_station as station_id
    from indego.trips_2022_q3
    where
        extract(hour from start_time) >= 7
        and extract(hour from start_time) < 10
) as all_trips
inner join stations
    using (station_id)
group by station_id, station_geog
order by num_trips desc
limit 5


/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
