/*
    How many trips started on one day and ended on a different day?

    Your result should have one column named trip_year, one column named
    trip_quarter, and one column named num_trips.
*/

-- Result: 2301 overnight trips for Q3 2021; 2060 overnight trips for Q3 2022; total 4361 overnight trips
-- Enter your SQL query here
SELECT
    (SELECT COUNT(*) FROM indego.trips_2021_q3 WHERE DATE(start_time) <> DATE(end_time)) AS overnight_2021,
    (SELECT COUNT(*) FROM indego.trips_2022_q3 WHERE DATE(start_time) <> DATE(end_time)) AS overnight_2022,
    (SELECT COUNT(*) FROM indego.trips_2021_q3 WHERE DATE(start_time) <> DATE(end_time))
    + (SELECT COUNT(*) FROM indego.trips_2022_q3 WHERE DATE(start_time) <> DATE(end_time)) AS total;

/*

    Hint 1: when you cast a TIMESTAMP to a DATE the time component of the value is simply stripped off

    Hint 2: Years, quarters, and other parts of DATEs or TIMESTAMPs can be retrieved from a TIMESTAMP using the
    [EXTRACT](https://www.postgresql.org/docs/12/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT)
    function.
*/
