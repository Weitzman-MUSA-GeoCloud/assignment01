/*
    What is the longest duration trip across the two quarters?

    Your result should have a single row with a single column named max_duration.
*/

-- Enter your SQL query here

select max(trips_2021_q3.duration) as max_duration
from indego.trips_2021_q3
full join indego.trips_2022_q3
    on indego.trips_2022_q3.trip_id = indego.trips_2021_q3.trip_id
