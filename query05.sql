/*
    What is the longest duration trip across the two quarters?

    Your result should have a single row with a single column named max_duration.
*/

-- Enter your SQL query here
select max(duration) as max_duration
from (
  select duration from indego.trips_2021_q3
  union all
  select duration from indego.trips_2022_q3
) t;

Why are there so many trips of this duration?
    
Many trips share the same maximum duration because extremely long or anomalous trips 
can be capped or truncated by the system at an upper limit. When many records hit that cap, 
they appear with the exact same maximum duration.
