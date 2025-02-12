#!/usr/bin/env bash

set -e

ENTRYPOINTDIR=$(readlink -f $(dirname $0))

# Activate the virtual environment that was created in the Dockerfile
source /workspace/env/bin/activate

# Load the data into the database
gzip --decompress "${ENTRYPOINTDIR}/data.sql.gz" --to-stdout | \
PGPASSWORD=${POSTGRES_PASS} \
psql \
    -h ${POSTGRES_HOST} \
    -p ${POSTGRES_PORT} \
    -U ${POSTGRES_USER} \
    -d ${POSTGRES_NAME} \
    > /dev/null

# Create a configuration file for the database connection
cat << EOF > /workspace/.env
POSTGRES_HOST=${POSTGRES_HOST}
POSTGRES_PORT=${POSTGRES_PORT}
POSTGRES_NAME=${POSTGRES_NAME}
POSTGRES_USER=${POSTGRES_USER}
POSTGRES_PASS=${POSTGRES_PASS}
EOF

# Run the tests, passing in any additional arguments from the command line
cd /workspace
npm run test "$@"
