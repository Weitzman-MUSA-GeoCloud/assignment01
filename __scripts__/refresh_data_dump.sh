#!/usr/bin/env bash

set -e

CURDIR=$(readlink -f $(dirname $0))
SCRIPTDIR=${CURDIR}
PGDATADIR=${CURDIR}/../__pgdata__
DATADIR=${CURDIR}/../__data__
ENTRYPOINTS=${CURDIR}/../__entrypoints__

CONTAINER_ENGINE=$(command -v podman || command -v docker)
CONTAINER_POSTGRES_HOST=localhost
CONTAINER_POSTGRES_PORT=15432
CONTAINER_POSTGRES_USER=postgres
CONTAINER_POSTGRES_NAME=postgres
CONTAINER_POSTGRES_PASS=postgres

# Make sure to use an image version that matches the version of pg_dump
CONTAINER_POSTGRES_MAJOR_VERSION=$(pg_dump --version | grep --only-matching --extended-regexp '[0-9]+' | head -n1)

# Start a PostGIS container (from postgis/postgis), mounting the ./pgdata/
# directory as /var/lib/postgresql/data. Make expose port 5432 as 15432 on the
# host.

rm -rf ${PGDATADIR}
mkdir -p ${PGDATADIR}

spinup_postgis_container() {
    echo >&2 "Starting PostGIS container..."
    CONTAINERID=$(${CONTAINER_ENGINE} run \
        --detach \
        --publish ${CONTAINER_POSTGRES_PORT}:5432 \
        --volume ${PGDATADIR}:/var/lib/postgresql/data \
        -e POSTGRES_PASSWORD=${CONTAINER_POSTGRES_PASS} \
        postgis/postgis:${CONTAINER_POSTGRES_MAJOR_VERSION}-master)

    # Poll pg_isready until the container is ready
    echo >&2 "Waiting for PostGIS container to start..."
    until pg_isready -h ${CONTAINER_POSTGRES_HOST} -p ${CONTAINER_POSTGRES_PORT} >&2; do
        sleep 5
    done

    echo ${CONTAINERID}
}

cleanup_postgis_container() {
    echo >&2 "Stopping PostGIS container..."
    ${CONTAINER_ENGINE} stop ${CONTAINERID}

    echo >&2 "Removing PostGIS container..."
    ${CONTAINER_ENGINE} rm ${CONTAINERID}

    echo >&2 "Removing ${PGDATADIR}..."
    rm -rf ${PGDATADIR}
}

# Start the PostGIS container
CONTAINERID=$(spinup_postgis_container)

# Run the bootstrap_data.sh script in the SCRIPTDIR, passing along the
# POSTGRES_ environment variables.
echo >&2 "Running bootstrap_data.sh script..."
POSTGRES_HOST=${CONTAINER_POSTGRES_HOST} \
POSTGRES_PORT=${CONTAINER_POSTGRES_PORT} \
POSTGRES_USER=${CONTAINER_POSTGRES_USER} \
POSTGRES_NAME=${CONTAINER_POSTGRES_NAME} \
POSTGRES_PASS=${CONTAINER_POSTGRES_PASS} \
${SCRIPTDIR}/bootstrap_data.sh || {
    cleanup_postgis_container
    exit 1
}

# Dump the database to a SQL file
echo >&2 "Dumping database to SQL file..."
PGPASSWORD=${CONTAINER_POSTGRES_PASS} pg_dump \
  -h ${CONTAINER_POSTGRES_HOST} \
  -p ${CONTAINER_POSTGRES_PORT} \
  -U ${CONTAINER_POSTGRES_USER} \
  -d ${CONTAINER_POSTGRES_NAME} \
  --clean \
  --if-exists \
  --no-owner \
  --no-privileges \
  --format plain \
  --file ${DATADIR}/data.sql || {
    cleanup_postgis_container
    exit 1
}

# Compress the SQL file
echo >&2 "Compressing the SQL file..."
gzip -c ${DATADIR}/data.sql > ${ENTRYPOINTS}/data.sql.gz || {
    cleanup_postgis_container
    exit 1
}

# Stop the container
cleanup_postgis_container

echo "Done!"