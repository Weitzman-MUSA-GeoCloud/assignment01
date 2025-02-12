/*
    What is the longest duration trip across the two quarters?

    Your result should have a single row with a single column named max_duration.
*/
-- Result: 1440 minutes (24 hours); system probably limits trips automatically to 24 hours
-- Enter your SQL query here
SELECT
    GREATEST(
        (SELECT MAX(duration) FROM indego.trips_2021_q3),
        (SELECT MAX(duration) FROM indego.trips_2022_q3)
    ) AS max_duration;
