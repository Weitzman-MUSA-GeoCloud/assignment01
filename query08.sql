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
    count(*) as num_trips
FROM(
    select start_station, start_time
    from indego.trips_2021_q3

    union ALL
    select start_station, start_time
    from indego.trips_2022_q3
)as t
join indego.station_statuses as s
on t.start_station = s.id::text
where extract(hour from t.start_time) in (7,8,9)
group by s.id, s.geog
order by (num_trips) DESC
LIMIT 5




/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
