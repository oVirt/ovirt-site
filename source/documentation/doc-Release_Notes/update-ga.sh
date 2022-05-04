#!/bin/bash
# Written by: Andrew Dahms
# Written on: 01 Feb, 2017

# .adoc file containing release update sections
MASTER=chap-Release_Notes.adoc

echo

type relnotes &> /dev/null

if [ $? -eq 0 ]
then
  echo -e "Found \e[1mrelnotes\e[0m."
else
  echo -e "\e[1mrelnotes\e[0m not installed. Exiting." >&2
  exit 1
fi

echo

echo -ne "Enter the major ystream release version. \
\nFor example, enter \e[1m4.3\e[0m for \e[1mRed Hat Virtualization 4.3.\e[0m \
\nMajor ystream release: "

read release

if [ -z "$release" ]
then
  echo -e "\nNo major ystream release specified. Exiting." >&2
  exit 1
fi

echo

echo -ne "Enter a comma-separated list of target milestones that are part of \
the release, with no whitespaces and no trailing comma.\nEnter the target \
milestones exactly as they are specified in Bugzilla. \
\nFor example: \e[1movirt-4.3.0,ovirt-4.3.1,ovirt-4.3.2\e[0m \
\nTarget milestone: "

read milestones

if [ -z "$milestones" ]
then
  echo -e "\nNo milestone specified. Exiting." >&2
  exit 1
fi

echo

echo -ne "Enter the latest target milestone from the list of target milestones \
included the release.
\nEnter the latest target milestone exactly as it is specified in Bugzilla. \
\nFor example, enter \e[1movirt-4.3.2\e[0m from the list of \
\e[1movirt-4.3.0,ovirt-4.3.1,ovirt-4.3.2\e[0m target milestones.
\nLatest target milestone: "

read milestone

if [ -z "$milestone" ]
then
  echo -e "\nNo milestone specified. Exiting."
  exit
fi

relnotes --product-set="Red Hat Virtualization" \
         --flags=rhevm-${release}-ga?,rhevm-${release}-ga+,ovirt-${release}?,ovirt-${release}+ \
         --file=topics/ref-${milestone}.adoc --milestones=${milestones} \
         --releases= --verbose --force --section --asciidoc --include-all --next \
         --title="Red Hat Virtualization ${release} General Availability (${milestone})"

if [ ! -f topics/ref-${milestone}.adoc ]
then
  echo -e "\nRunning the \e[1mrelnotes\e[0m tool failed. Exiting." >&2
  exit 1
fi

echo -e "Updating the \e[1m$MASTER\e[0m file.\n"

cat >> $MASTER <<EOF

include::topics/ref-${milestone}.adoc[leveloffset=+1]

EOF

echo "Done."
