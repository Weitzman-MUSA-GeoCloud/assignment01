#!/usr/bin/env bash

set -e

ENTRYPOINTDIR=$(readlink -f $(dirname $0))

# Activate the virtual environment that was created in the Dockerfile
source /workspace/env/bin/activate

# Run the linter
cd /workspace
npm run lint "$@"
