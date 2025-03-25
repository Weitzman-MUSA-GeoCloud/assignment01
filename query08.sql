/*
    Give the five most popular starting stations across all years between 7am
    and 9:59am.

    Your result should have 5 records with three columns, one for the station id
    (named `station_id`), one for the point geography of the station (named
    `station_geog`), and one for the number of trips that started at that
    station (named `num_trips`).
*/

-- Enter your SQL query here

with morning_trips as (
    select start_station::int as sid, count(*) as cnt
    from indego.trips_2021_q3
    where extract(hour from start_time) between 7 and 9
    group by start_station

    union all

    select start_station::int as sid, count(*) as cnt
    from indego.trips_2022_q3
    where extract(hour from start_time) between 7 and 9
    group by start_station
)

select
    mt.sid,
    ss.geog,
    sum(mt.cnt) as total_trips
from morning_trips mt
left join indego.station_statuses ss
    on mt.sid = ss.id
group by mt.sid, ss.geog
order by total_trips desc
limit 5;

/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
