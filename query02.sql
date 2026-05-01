/*
    What is the percent change in trips in Q3 2022 as compared to Q3 2021?

    Using only the tables from Q3 2021 and Q3 2022 (i.e. not directly using the
    number calculated in the previous question), find the percent change in the
    number of trips in Q3 2022 as compared to 2021. Round your answer to two
    decimal places and name the resulting field `perc_change`.

    Remember you can do calculations in the select clause.
*/

-- Enter your SQL query here

SELECT ROUND(((trips_2022 - trips_2021) * 100.0 / trips_2021), 2) AS perc_change
FROM
    (
        SELECT
            (SELECT COUNT(*) FROM indego.trips_2021_q3) AS trips_2021,
            (SELECT COUNT(*) FROM indego.trips_2022_q3) AS trips_2022
    ) AS trip_counts;
