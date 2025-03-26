/*
    List all the passholder types and number of trips for each across all years.

    In other words, in one query, give a list of all `passholder_type` options
    and the number of trips taken by `passholder_type`. Your results should have
    two columns: `passholder_type` and `num_trips`.
*/

-- Enter your SQL query here
with user_type_trips as (
    select 
        passholder_type as passholder_type, 
        count(*) as trips
    from indego.trips_2021_q3
    group by passholder_type

    union all

    select 
        passholder_type, 
        count(*) as trips
    from indego.trips_2022_q3
    group by passholder_type
)

select
    passholder_type,
    sum(trips) as num_trips
from user_type_trips
group by passholder_type;
