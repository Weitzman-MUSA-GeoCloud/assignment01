/*
    List all the passholder types and number of trips for each across all years.

    In other words, in one query, give a list of all `passholder_type` options
    and the number of trips taken by `passholder_type`. Your results should have
    two columns: `passholder_type` and `num_trips`.
*/

-- Enter your SQL query here
with passholders as (
    select
        passholder_type,
        count(*) as num_trips
    from trips_2021_q3
    group by passholder_type
    union
    select
        passholder_type,
        count(*) as num_trips
    from trips_2022_q3
    group by passholder_type
)
select
    passholder_type,
    sum(num_trips) as num_trips
from passholders
group by passholder_type
