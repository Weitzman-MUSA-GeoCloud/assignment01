-- Active: 1769627709257@@127.0.0.1@5432@Assignment-2_MUSA
/*
    How many trips started on one day and ended on a different day?

    Your result should have one column named trip_year, one column named
    trip_quarter, and one column named num_trips.
*/

-- Enter your SQL query here
SELECT
    2021 AS trip_year,
    3 AS trip_quarter,
    COUNT(*) AS num_trips
FROM indego.trips_2021_q3
WHERE start_time::date <> end_time::date

UNION ALL

SELECT
    2022 AS trip_year,
    3 AS trip_quarter,
    COUNT(*) AS num_trips
FROM indego.trips_2022_q3
WHERE start_time::date <> end_time::date
ORDER BY trip_year, trip_quarter;



/*

    Hint 1: when you cast a TIMESTAMP to a DATE the time component of the value is simply stripped off

    Hint 2: Years, quarters, and other parts of DATEs or TIMESTAMPs can be retrieved from a TIMESTAMP using the
    [EXTRACT](https://www.postgresql.org/docs/12/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT)
    function.
*/
