/*
    How many trips in each quarter were shorter than 10 minutes?

    Your result should have two records with three columns, one for the year
    (named `trip_year`), one for the quarter (named `trip_quarter`), and one for
    the number of trips (named `num_trips`).
*/

-- Enter your SQL query here
select
    2021 as trip_year,
    3 as trip_quarter,
    count(*) as num_trips
from
    indego.trips_2021_q3
where
    duration < 10

union

select
    2022 as trip_year,
    3 as trip_quarter,
    count(*) as num_trips
from
    indego.trips_2022_q3
where
    duration < 10;
