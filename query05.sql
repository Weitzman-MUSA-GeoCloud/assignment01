/*
    What is the longest duration trip across the two quarters?

    Your result should have a single row with a single column named max_duration.
*/

-- Enter your SQL query here

with duration_2021 as (
    select max(duration) as max_duration_2021
    from indego.trips_2021_q3
),

duration_2022 as (
    select max(duration) as max_duration_2022
    from indego.trips_2022_q3
)

select greatest(duration_2021.max_duration_2021, duration_2022.max_duration_2022) as max_duration
from duration_2021, duration_2022;
