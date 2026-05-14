/*
    What is the percent change in trips in Q3 2022 as compared to Q3 2021?

    Using only the tables from Q3 2021 and Q3 2022 (i.e. not directly using the
    number calculated in the previous question), find the percent change in the
    number of trips in Q3 2022 as compared to 2021. Round your answer to two
    decimal places and name the resulting field `perc_change`.

    Remember you can do calculations in the select clause.
*/

-- Enter your SQL query here
SELECT
    ROUND(
        (
            (T2022.COUNT_2022 - T2021.COUNT_2021) * 100.0
        ) / T2021.COUNT_2021,
        2
    ) AS PERC_CHANGE
FROM
    (SELECT COUNT(*) AS COUNT_2021 FROM INDEGO.TRIPS_2021_Q3) AS T2021,
    (SELECT COUNT(*) AS COUNT_2022 FROM INDEGO.TRIPS_2022_Q3) AS T2022;
