#!/bin/bash
#
# This script is intended to update the documentation. You pass it the
# version number of the specification of the API, and then it will
# download the specification, and extract the 'model.adoc' file from it.
# For example, to update the documentation to version 4.4.12 do the
# following:
#
# ./update.sh 4.4.12
#

# Get the command line parameters:
if [ "$#" -ne 1 ]
then
  echo "Exactly one argument is required, the version of the model, for example '4.2.38'."
  exit 1
fi

# Get the version:
version="$1"

# Calculate the URL of the artifact:
base="http://brewweb.devel.redhat.com/brewroot/repos"
tag="rhevm-4.4-openjdk-11-rhel-7-mead-build"
path="latest/maven/org/ovirt/engine/api/model/${version}"
file="model-${version}-javadoc.jar"
url="${base}/${tag}/${path}/${file}"

# Download the artifact:
code=$(
  curl \
  --insecure \
  --silent \
  --output "${file}" \
  --write-out '%{http_code}' \
  "${url}"
)
if [ "${code}" -ne 200 ]
then
  echo "Can't download model file '${file}' from URL '${url}'."
  exit 1
fi

# Extract the 'model.adoc' file from the artifact:
unzip -o "${file}" model.adoc
if [ "$?" -ne 0 ]
then
  echo "Can't extract file 'model.adoc' from the model file."
  exit 1
fi

# Bye:
echo "The 'model.adoc' file has been updated."
exit 0
