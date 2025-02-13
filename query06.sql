/*
    How many trips in each quarter were shorter than 10 minutes?

    Your result should have two records with three columns, one for the year
    (named `trip_year`), one for the quarter (named `trip_quarter`), and one for
    the number of trips (named `num_trips`).
*/

-- Enter your SQL query here

select
    3 as trip_quarter,
    extract(year from coalesce(y2021.start_time, y2022.start_time)) as trip_year,
    count(*) as num_trips
from indego.trips_2021_q3 as y2021
full join indego.trips_2022_q3 as y2022
    on y2021.trip_id = y2022.trip_id
where y2021.duration < 10 or y2022.duration < 10
group by trip_year;
