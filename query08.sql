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
    start_station as station_id,
    st_point(start_lon, start_lat)::geography as stations_geog,
    count(*) as num_trips
from (
    select * from indego.trips_2021_q3
    union all
    select * from indego.trips_2022_q3
) as all_trips
where extract(hour from start_time) between 7 and 9
group by start_station, start_lon, start_lat
order by num_trips desc
limit 5


/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
