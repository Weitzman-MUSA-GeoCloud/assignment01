#!/usr/bin/env bash

set -e
set -x

# Change into the container's workspace
cd /workspace

# Activate the virtual environment that was created in the Dockerfile
source env/bin/activate

ENTRYPOINTDIR=$(readlink -f $(dirname $0))

# Load the data into the database
gzip --decompress "${ENTRYPOINTDIR}/data.sql.gz" --to-stdout | \
PGPASSWORD=${POSTGRES_PASS} \
psql \
    -h ${POSTGRES_HOST} \
    -p ${POSTGRES_PORT} \
    -U ${POSTGRES_USER} \
    -d ${POSTGRES_NAME}

# Create a configuration file for the database connection
cat << EOF > .env
POSTGRES_HOST=${POSTGRES_HOST}
POSTGRES_PORT=${POSTGRES_PORT}
POSTGRES_NAME=${POSTGRES_NAME}
POSTGRES_USER=${POSTGRES_USER}
POSTGRES_PASS=${POSTGRES_PASS}
EOF

# Run the tests, passing in any additional arguments from the command line
npm run test "$@"
