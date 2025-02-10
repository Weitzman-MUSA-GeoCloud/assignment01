#!/usr/bin/env bash

set -e
set -x

ENTRYPOINTDIR=$(readlink -f $(dirname $0))

# Activate the virtual environment that was created in the Dockerfile
source /workspace/env/bin/activate

# Run the linter
cd ${ENTRYPOINTDIR}/..
npm run lint "$@"
