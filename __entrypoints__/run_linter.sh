#!/usr/bin/env bash

set -e
set -x

# Change into the container's workspace
cd /workspace

# Activate the virtual environment that was created in the Dockerfile
source env/bin/activate

npm run lint assignment01
