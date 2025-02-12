/*
    How many trips started on one day and ended on a different day?

    Your result should have one column named trip_year, one column named
    trip_quarter, and one column named num_trips.
*/

-- Enter your SQL query here

select
extract(year from coalesce(y2021.start_time, y2022.start_time)) as trip_year,
3 as trip_quarter,
count(*) as num_trips
from indego.trips_2021_q3 as y2021
full join indego.trips_2022_q3 as y2022
on y2021.trip_id = y2022.trip_id
where cast(y2021.start_time as date) != cast(y2021.end_time as date) OR cast(y2022.start_time as date) != cast(y2022.end_time as date)
group by trip_year;

/*

    Hint 1: when you cast a TIMESTAMP to a DATE the time component of the value is simply stripped off

    Hint 2: Years, quarters, and other parts of DATEs or TIMESTAMPs can be retrieved from a TIMESTAMP using the
    [EXTRACT](https://www.postgresql.org/docs/12/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT)
    function.
*/
