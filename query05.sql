/*
    What is the longest duration trip across the two quarters?

    Your result should have a single row with a single column named max_duration.
*/

-- Enter your SQL query here
with durations as (
    select duration
    from trips_2021_q3
    union all
    select duration
    from trips_2022_q3
)
select
    max(duration) as max_duration
from durations;