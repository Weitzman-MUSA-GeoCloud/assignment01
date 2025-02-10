# Postgres Shell & Terminal commands for Byron

## Postgres Shell Commands

CREATE SCHEMA indego;

CREATE EXTENSION postgis;

## Terminal Commands

ogr2ogr \
    -f "PostgreSQL" \
    -nln station_statuses \
    -lco SCHEMA=indego \
    -lco GEOMETRY_NAME=geog \
    -lco GEOMETRY_TYPE=geography \
    -lco OVERWRITE=YES \
PG:"host=localhost user=postgres dbname=assignment01 password=7777" \
"data/station_status_20250210.geojson"