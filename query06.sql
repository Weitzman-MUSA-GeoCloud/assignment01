/*
    How many trips in each quarter were shorter than 10 minutes?

    Your result should have two records with three columns, one for the year
    (named `trip_year`), one for the quarter (named `trip_quarter`), and one for
    the number of trips (named `num_trips`).
*/

-- Enter your SQL query here
with trips21 as (
    select
        2021 as trip_year,
        3 as trip_quarter,
        count(case when duration < 10 then duration end) as num_trips
    from trips_2021_q3
),
trips22 as (
    select
        2022 as trip_year,
        3 as trip_quarter,
        count(case when duration < 10 then duration end) as num_trips
    from trips_2022_q3
)
select *
from trips21
union all
select *
from trips22;