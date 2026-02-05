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
s.id as station_id,
s.geog as station_geog,
t.num_trips
from (
select start_station,
count(*) as num_trips
from (
select start_station, start_time from indego.trips_2021_q3
union all
select start_station, start_time from indego.trips_2022_q3
) as trips
where extract (hour from trips.start_time) between 7 and 9
group by start_station
order by num_trips desc
limit 5
) as t
join indego.station_statuses s
on s.id::text = t.start_station;

/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
