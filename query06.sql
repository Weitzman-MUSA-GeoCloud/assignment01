/*
    How many trips in each quarter were shorter than 10 minutes?

    Your result should have two records with three columns, one for the year
    (named `trip_year`), one for the quarter (named `trip_quarter`), and one for
    the number of trips (named `num_trips`).
*/

-- Enter your SQL query here
with combined as (
    select start_time, duration from indego.trips_2021_q3
    union all
    select start_time, duration from indego.trips_2022_q3
)
select
    extract(year from start_time) as yr,
    extract(quarter from start_time) as qtr,
    count(*) as trips
from combined
where duration < 10
group by yr, qtr;