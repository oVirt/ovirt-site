#!/bin/bash

TEMPDIR=$(mktemp -d)
export TEMPDIR
wget --no-verbose --recursive --directory-prefix=$TEMPDIR  --no-host-directories http://127.0.0.1:4000
diff -ru _site $TEMPDIR
