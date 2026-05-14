/*
    How many trips in each quarter were shorter than 10 minutes?

    Your result should have two records with three columns, one for the year
    (named `trip_year`), one for the quarter (named `trip_quarter`), and one for
    the number of trips (named `num_trips`).
*/

-- Enter your SQL query here
select
    extract(year from start_time) as trip_year,
    extract(quarter from start_time) as trip_quarter,
    count(*) as num_trips
from
    indego.trips_2021_q3
where
    duration < 10
group by
    trip_year,
    trip_quarter
union
select
    extract(year from start_time) as trip_year,
    extract(quarter from start_time) as trip_quarter,
    count(*) as num_trips
from
    indego.trips_2022_q3
where
    duration < 10
group by
    trip_year,
    trip_quarter;

/*
AI used to help with query. Free model Claude Haiku 4.5.

Prompt:
Don't give me answer. My query was working earlier for
one of the years, but when I duplicate query for other
year to create one query there's error. Provide
hint for next step plus link to documentation.

(I was missing UNION to combine the two queries.)
*/
