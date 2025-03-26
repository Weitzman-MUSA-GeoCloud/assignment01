/*
    What is the longest duration trip across the two quarters?

    Your result should have a single row with a single column named max_duration.
*/

-- Enter your SQL query here
with d1 as (
    select max(duration) as dur_2021
    from indego.trips_2021_q3
),

d2 as (
    select max(duration) as dur_2022
    from indego.trips_2022_q3
)

select greatest(d1.dur_2021, d2.dur_2022) as max_duration
from d1, d2;

