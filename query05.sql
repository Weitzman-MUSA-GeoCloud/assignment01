/*
    What is the longest duration trip across the two quarters?

    Your result should have a single row with a single column named max_duration.
*/

with
durations as (
    select duration from indego.trips_2022_q3
    union all
    select duration from indego.trips_2021_q3
)
select max(duration) as max_duration
from durations;

/*
Why are there so many trips of this duration?
Answer: 1,440 minutes is equal to 24 hours; when durations are logged, a maximum may have been set a priori.
*/