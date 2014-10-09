#!/bin/bash

# Support a custom Docker ID
DOCKERID=$1

# Generate a Docker ID (if not specified)
: ${DOCKERID:=springboard-$RANDOM$RANDOM}

# Save Docker ID to local .dockerid file
echo $DOCKERID > .dockerid

if [ docker &>/dev/null ]
then
  # Ensure we have the latest & greatest base image
  docker pull `grep ^FROM Dockerfile | cut -f2 -d' '`

  # Build docker image
  docker build -t `cat .dockerid` .
  echo "Built Springboard docker image $DOCKERID"
else
  echo "Please install Docker."
  echo "See https://docs.docker.com/installation/#installation"
fi
