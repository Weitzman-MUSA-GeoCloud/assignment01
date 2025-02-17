/*
    How many trips started on one day and ended on a different day?

    Your result should have one column named trip_year, one column named
    trip_quarter, and one column named num_trips.
*/

-- Enter your SQL query here
with both_years as (
    select
        extract(year from start_time) as trip_year,
        extract(quarter from start_time) as trip_quarter,
        count(*) as num_trips
    from indego.trips_2021_q3
    where date(start_time) != date(end_time)
    group by trip_year, trip_quarter
    union all
    select
        extract(year from start_time) as trip_year,
        extract(quarter from start_time) as trip_quarter,
        count(*) as num_trips
    from indego.trips_2022_q3
    where date(start_time) != date(end_time)
    group by trip_year, trip_quarter
)

select
    trip_year,
    num_trips,
    trip_quarter
from both_years

/*

    Hint 1: when you cast a TIMESTAMP to a DATE the time component of the value
    is
    simply stripped off

    Hint 2: Years, quarters, and other parts of DATEs or TIMESTAMPs can be
    retrieved from a
    TIMESTAMP using the
    [EXTRACT](https://www.postgresql.org/docs/12/
    functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT)
    function.
*/
