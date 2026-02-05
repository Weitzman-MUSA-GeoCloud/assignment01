/*
    How many trips started on one day and ended on a different day?

    Your result should have one column named trip_year, one column named
    trip_quarter, and one column named num_trips.
*/

-- Enter your SQL query here
select
extract (year from start_time) as trip_year,
extract (quarter from start_time) as trip_quarter,
count(*) as num_trips
from
(select start_time, end_time from indego.trips_2021_q3
union all
select start_time, end_time from indego.trips_2022_q3)
as t
where t.start_time::date != t.end_time::date
group by 1, 2;



/*

    Hint 1: when you cast a TIMESTAMP to a DATE the time component of the value is simply stripped off

    Hint 2: Years, quarters, and other parts of DATEs or TIMESTAMPs can be retrieved from a TIMESTAMP using the
    [EXTRACT](https://www.postgresql.org/docs/12/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT)
    function.
*/
