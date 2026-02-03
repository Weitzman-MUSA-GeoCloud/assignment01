/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

-- Enter your SQL query here
SELECT
  COUNT(*) AS num_stations
FROM indego.station_statuses
WHERE indego.ST_Distance(
        geog,
        indego.ST_SetSRID(
          indego.ST_MakePoint(-75.192584, 39.952415),
          4326
        )::indego.geography
      ) <= 1000;
