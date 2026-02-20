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
    all_trips.start_station as station_id,
    indego.station_statuses.geog as station_geog,
    count(*) as num_trips
from (
    select
        start_station,
        start_time
    from indego.trips_2021_q3
    union all
    select
        start_station,
        start_time
    from indego.trips_2022_q3
) as all_trips
inner join indego.station_statuses
    on all_trips.start_station::integer = indego.station_statuses.id
where
    extract(hour from all_trips.start_time) between 7 and 9
group by
    all_trips.start_station,
    indego.station_statuses.geog
order by
    num_trips desc
limit 5;

/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
