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
        (COUNT(indego.trips_2022_q3.trip_id) - 
         COUNT(indego.trips_2021_q3.trip_id)) 
        * 100.0 
        / NULLIF(COUNT(indego.trips_2021_q3.trip_id), 0), 
    2)::TEXT || '%' AS perc_change
FROM indego.trips_2021_q3
FULL OUTER JOIN indego.trips_2022_q3 ON indego.trips_2021_q3.trip_id = indego.trips_2022_q3.trip_id;



    If you want to get fancier here, you can cast the result to a string and
    concatenate a '%' to the end. For example:

        (10 + 3.2)::text || '%' AS perc_change

    This uses the type casting (number to string) and string concatenation
    operator (`||`, double pipes) that's essentially a `+` for strings.
*/
