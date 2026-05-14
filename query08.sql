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
    station_statuses.id as station_id,
    station_statuses.geog as station_geog,
    t.num_trips
from (
    select
        trips.start_station,
        count(*) as num_trips
    from (
        select
            trips_2021_q3.start_station,
            trips_2021_q3.start_time
        from indego.trips_2021_q3
        union all
        select
            trips_2022_q3.start_station,
            trips_2022_q3.start_time
        from indego.trips_2022_q3
    ) as trips
    where extract(hour from trips.start_time) between 7 and 9
    group by
        trips.start_station
) as t
inner join indego.station_statuses
    on station_statuses.id::text = t.start_station
order by
    t.num_trips desc,
    station_statuses.id asc
limit 5;

/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
