/*
    What is the longest duration trip across the two quarters?

    Your result should have a single row with a single column named max_duration.
*/

-- Enter your SQL query here
with both_duration as (
    select duration from indego.trips_2021_q3 as duration_21
    UNION ALL
    select duration from indego.trips_2022_q3 as duration_22)
select MAX(duration) as max_duration from both_duration;