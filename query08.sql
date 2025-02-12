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
    stations.id as station_id,
    stations.geog as station_geog,
    count(trips.trip_id) as num_trips
from
    (
        select
            y1.start_station,
            y1.trip_id
        from indego.trips_2021_q3 as y1
        where extract(hour from y1.start_time) >= 7 and extract(hour from y1.start_time) < 10
        union
        select
            y2.start_station,
            y2.trip_id
        from indego.trips_2022_q3 as y2
        where extract(hour from y2.start_time) >= 7 and extract(hour from y2.start_time) < 10
    ) as trips
left join indego.station_statuses as stations on stations.id::text = trips.start_station
group by stations.id, stations.geog
having stations.id is not null
order by num_trips desc
limit 5

/*
    Hint: Use the `EXTRACT` function to get the hour of the day from the
    timestamp.
*/
