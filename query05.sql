/*
    What is the longest duration trip across the two quarters?

    Your result should have a single row with a single column named max_duration.
*/
<<<<<<< HEAD

=======
>>>>>>> ecb232b9506762c67f221864e43782df964a27bc
SELECT MAX(duration) AS max_duration
FROM (
    SELECT duration FROM indego.trips_2021_q3
    UNION ALL
    SELECT duration FROM indego.trips_2022_q3
);
