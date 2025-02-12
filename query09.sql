/*
    List all the passholder types and number of trips for each across all years.

    In other words, in one query, give a list of all `passholder_type` options
    and the number of trips taken by `passholder_type`. Your results should have
    two columns: `passholder_type` and `num_trips`.
*/
select
    passholder_type,
    count(trip_id) as num_trips
from (
    select
        passholder_type,
        trip_id
    from indego.trips_2021_q3
    union
    select
        passholder_type,
        trip_id
    from indego.trips_2022_q3
)
group by passholder_type
having passholder_type is not null
-- Enter your SQL query here
