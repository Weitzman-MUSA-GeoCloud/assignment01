/*
    How many trips in each quarter were shorter than 10 minutes?

    Your result should have two records with three columns, one for the year
    (named `trip_year`), one for the quarter (named `trip_quarter`), and one for
    the number of trips (named `num_trips`).
*/

-- Enter your SQL query here
select
    trip_year,
    trip_quarter,
    count(*) as num_trips
from (
    select
        2021 as trip_year,
        3 as trip_quarter
    from indego.trips_2021_q3
    where duration < 10
    union all
    select
        2022 as trip_year,
        3 as trip_quarter
    from indego.trips_2022_q3
    where duration < 10
) as all_trips
group by trip_year, trip_quarter
