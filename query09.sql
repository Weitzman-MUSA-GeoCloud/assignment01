/*
    List all the passholder types and number of trips for each across all years.

    In other words, in one query, give a list of all `passholder_type` options
    and the number of trips taken by `passholder_type`. Your results should have
    two columns: `passholder_type` and `num_trips`.
*/

WITH temporary_21_22 AS(
	SELECT *
	FROM indego.trips_2021_q3 AS trips_2021_q3
	UNION ALL
	SELECT *
	FROM indego.trips_2022_q3 AS trips_2022_q3
)
SELECT COUNT(*) AS num_trips,
passholder_type AS passholder_type
FROM temporary_21_22
GROUP BY passholder_type;
