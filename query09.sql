/*
    List all the passholder types and number of trips for each across all years.

    In other words, in one query, give a list of all `passholder_type` options
    and the number of trips taken by `passholder_type`. Your results should have
    two columns: `passholder_type` and `num_trips`.
*/

-- Enter your SQL query here
select
    passholder_type,
    count(trip_id) as num_trips
from (
    select * from indego.trips_2021_q3
    union all
    select * from indego.trips_2022_q3
) as all_trips
group by
    passholder_type;

/*
AI used to help with query. Free model Claude Haiku 4.5.

Prompt:

Don't give me answer. Looks like distinct passholder
types are being duplicated due to different years.
Is there a function that can help? Give a hint
for next step plus link to documentation.

(Use UNION ALL instead of UNION.)
*/
