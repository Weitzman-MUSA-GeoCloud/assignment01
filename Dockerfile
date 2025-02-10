# Use an LTS Ubuntu as a base image
FROM ubuntu:24.04

# Install the necessary system packages
RUN apt update && apt install -y \
    postgresql-client \
    nodejs npm \
    python3 python3-pip python3-venv

# Clean up the package manager cache
RUN apt clean

# Create a workspace directory
WORKDIR /workspace

# Copy the files with dependencies into the container
COPY package.json /workspace/package.json
COPY package-lock.json /workspace/package-lock.json
COPY requirements.txt /workspace/requirements.txt

# Install the node packages
RUN npm install

# Use bash as the shell for any subsequent commands; this is necessary for
# activating the python virtual environment with the `source` command.
SHELL ["/bin/bash", "-c"]

# Install the python packages
RUN python3 -m venv env && \
    source env/bin/activate && \
    pip install -r requirements.txt

# Expect that the assignment's SQL files and linting configuration files will
# have been mounted into the container at /assignment01
ENTRYPOINT [ "/assignment01/__entrypoints__/run_linter.sh" ]
