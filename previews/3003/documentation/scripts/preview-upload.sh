#!/bin/bash
# Avital Pinnick, 2022
# This script builds a downstream preview with Asciidoctor and uploads it to your remote drive.
# You must have Asciidoctor installed ($ sudo dnf install asciidoctor).
# You must be in the same directory as the master.adoc file.
# You must set up a remote drive and copy your SSH key.
# You must also clean up your drive manually from time to time so that you do not run out of space.

# I decided not to use the date as part of the path. We can add it if we want to keep versions separated by dates as well as GitHub branches.
# DATE=$(date +"%m-%d-%y")

# Input variables
KERB="$1"
GEO="$2"

if [ "$1" == "" ] ; then
  echo -e "\nUsage: preview-upload.sh <kerberos_id> <geo>\nExample: preview-upload.sh apinnick tlv\n"
  exit 0
fi

# This is the directory or guide name so that different books can be uploaded for the same branch, for example, 'branch_name/administration_guide/'.
DIR=$(pwd | xargs basename)
BRANCH=$(git branch --show-current)

asciidoctor -o index.html master.adoc

if ssh $KERB@file.$GEO.redhat.com "test -e ~/public_html/$BRANCH/$DIR/"; then
  echo -e "\nDirectory exists. Updating preview."
  rsync -az --info=progress2 --human-readable index.html images ../common $KERB@file.$GEO.redhat.com:~/public_html/$BRANCH/$DIR/
else
  echo -e "\nCreating directory and uploading preview."
  rsync -az --rsync-path="mkdir -p ~/public_html/$BRANCH/$DIR/ && rsync" --info=progress2 --human-readable index.html images ../common $KERB@file.$GEO.redhat.com:~/public_html/$BRANCH/$DIR/
fi

echo -e "\nPreview URL: http://file.$GEO.redhat.com/$KERB/$BRANCH/$DIR/index.html"
echo -e "***Important***\nYou must be connected to the VPN to view this file.\n"

xdg-open http://file.$GEO.redhat.com/$KERB/$BRANCH/$DIR/index.html

rm index.html
