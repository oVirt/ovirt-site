#!/bin/bash

DOCKERID=`cat .dockerid`

echo "Running docker image $DOCKERID"

docker run -v $PWD:/opt/website -p 4567:4567 -it $DOCKERID $@
