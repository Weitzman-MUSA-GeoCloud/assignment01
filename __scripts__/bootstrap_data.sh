#!/bin/env bash

set -e
set -x

POSTGRES_HOST="localhost"
POSTGRES_PORT="5432"
POSTGRES_NAME="assignment1"
POSTGRES_USER="postgres"
POSTGRES_PASS='P123i,./g456'

SCRIPTDIR=$(readlink -f $(dirname $0))
DATADIR=$(readlink -f $(dirname $0)/../__data__)
mkdir -p ${DATADIR}

# Download and unzip data (if not already downloaded)
echo "Downloading data..."
mkdir -p ${DATADIR}

if [ ! -f ${DATADIR}/indego-trips-2022-q3.zip ]; then
    echo "Downloading 2022 Q3 trip data..."
    curl -L https://bicycletransit.wpenginepowered.com/wp-content/uploads/2022/12/indego-trips-2022-q3.zip > ${DATADIR}/indego-trips-2022-q3.zip
    unzip -o ${DATADIR}/indego-trips-2022-q3.zip -d ${DATADIR}
else
    echo "** 2022 Q3 trip data already downloaded."
fi

if [ ! -f ${DATADIR}/indego-trips-2021-q3.zip ]; then
    echo "Downloading 2021 Q3 trip data..."
    curl -L https://bicycletransit.wpenginepowered.com/wp-content/uploads/2021/10/indego-trips-2021-q3.zip > ${DATADIR}/indego-trips-2021-q3.zip
    unzip -o ${DATADIR}/indego-trips-2021-q3.zip -d ${DATADIR}
else
    echo "** 2021 Q3 trip data already downloaded."
fi

if [ ! -f ${DATADIR}/indego-station-statuses.geojson ]; then
    echo "Downloading station status data..."
    curl -L http://www.rideindego.com/stations/json/ > ${DATADIR}/indego-station-statuses.geojson
else
    echo "** Station status data already downloaded."
fi

# Poll pg_isready until the container is ready
echo "Waiting for PostGIS container to start..."
until pg_isready -h ${POSTGRES_HOST} -p ${POSTGRES_PORT}; do
    sleep 5
done

# Initialize table structure
echo "Creating database and initializing table structure..."
PGPASSWORD=${POSTGRES_PASS} psql \
  -h ${POSTGRES_HOST} \
  -p ${POSTGRES_PORT} \
  -U ${POSTGRES_USER} \
  -d ${POSTGRES_NAME} \
  -f "${SCRIPTDIR}/create_trip_tables.sql"

# Load trip data into database
echo "Loading trip data into database..."
PGPASSWORD=${POSTGRES_PASS} psql \
  -h ${POSTGRES_HOST} \
  -p ${POSTGRES_PORT} \
  -U ${POSTGRES_USER} \
  -d ${POSTGRES_NAME} \
  -c "\copy indego.trips_2021_q3 FROM '${DATADIR}/indego-trips-2021-q3.csv' DELIMITER ',' CSV HEADER;"
PGPASSWORD=${POSTGRES_PASS} psql \
  -h ${POSTGRES_HOST} \
  -p ${POSTGRES_PORT} \
  -U ${POSTGRES_USER} \
  -d ${POSTGRES_NAME} \
  -c "\copy indego.trips_2022_q3 FROM '${DATADIR}/indego-trips-2022-q3.csv' DELIMITER ',' CSV HEADER;"

# Load station data into database
echo "Loading station data into database..."
ogr2ogr \
  -f "PostgreSQL" \
  -nln "indego.station_statuses" \
  -lco "OVERWRITE=yes" \
  -lco "GEOM_TYPE=geography" \
  -lco "GEOMETRY_NAME=geog" \
  PG:"host=${POSTGRES_HOST} port=${POSTGRES_PORT} dbname=${POSTGRES_NAME} user=${POSTGRES_USER} password=${POSTGRES_PASS}" \
  ${DATADIR}/indego-station-statuses.geojson