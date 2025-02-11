# Use an LTS Ubuntu as a base image
FROM ubuntu:24.04

# Install the necessary system packages, and then clean up
RUN apt update && \
    apt install -y \
        postgresql-client \
        nodejs npm \
        python3 python3-pip python3-venv && \
    apt clean

# Create a workspace directory
WORKDIR /workspace

# Copy the files with dependencies into the container
COPY package.json /workspace/package.json
COPY package-lock.json /workspace/package-lock.json
COPY requirements.txt /workspace/requirements.txt

# Use bash as the shell for any subsequent commands; this is necessary for
# activating the python virtual environment with the `source` command.
SHELL ["/bin/bash", "-c"]

# Install the node & python packages
RUN npm install && \
    python3 -m venv env && \
    source env/bin/activate && \
    pip install -r requirements.txt

# Expect that the assignment's SQL files and linting configuration files will
# have been mounted into the container at /assignment01
CMD ["echo", "Please mount the assignment files into the container at /assignment01 and run the assignment scripts from there."]