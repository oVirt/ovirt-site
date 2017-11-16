#!/bin/bash

DOCKERID=`cat .dockerid`

echo "Running docker image $DOCKERID"

docker run -u $UID -v $PWD:/opt/website:z -p 4567:4567 -it $DOCKERID $@
