/*
    What is the longest duration trip across the two quarters?

    Your result should have a single row with a single column named max_duration.
*/

select max(duration) as max_duration
from (
    select duration from indego.trips_2021_q3
    union all
    select duration from indego.trips_2022_q3
) as all_trips
