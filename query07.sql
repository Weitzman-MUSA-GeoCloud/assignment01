/*
    How many trips started on one day and ended on a different day?

    Your result should have one column named trip_year, one column named
    trip_quarter, and one column named num_trips.
*/

-- Enter your SQL query here
with combined as (
    select *
    from trips_2021_q3
    union all
    select *
    from trips_2022_q3
),
less_cols as (
    select
        extract(year from start_time) as trip_year,
        extract(quarter from start_time) as trip_quarter,
        extract(day from start_time) as start_day,
        extract(day from end_time) as end_day
    from combined
)
select
    trip_year,
    trip_quarter,
    count(case when start_day != end_day then trip_year end) as num_trips
from less_cols
group by trip_year, trip_quarter;

/*

    Hint 1: when you cast a TIMESTAMP to a DATE the time component of the value is simply stripped off

    Hint 2: Years, quarters, and other parts of DATEs or TIMESTAMPs can be retrieved from a TIMESTAMP using the
    [EXTRACT](https://www.postgresql.org/docs/12/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT)
    function.
*/
