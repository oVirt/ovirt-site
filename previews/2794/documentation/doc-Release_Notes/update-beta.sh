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
the Beta release, with no whitespaces and no trailing comma.\nEnter the target \
milestones exactly as they are specified in Bugzilla. \
\nFor example: \e[1movirt-4.3.0,ovirt-4.3.1\e[0m \
\nTarget milestone: "

read milestones

if [ -z "$milestones" ]
then
  echo -e "\nNo milestone specified. Exiting." >&2
  exit 1
fi

echo

echo -ne "Enter your Bugzilla user name, including the \e[4m@redhat.com\e[0m part: "

read username

if [ -z "$username" ]
then
  echo -e "\nNo user name specified. Exiting." >&2
  exit 1
fi

echo

echo -n "Enter your Bugzilla password: "

read -s password

if [ -z "$password" ]
then
  echo -e "\nNo password specified. Exiting." >&2
  exit 1
else
  echo -e "\n\nAll values specified, running the \e[1mrelnotes\e[0m tool...\n"
fi

relnotes --username=${username} --password=${password} --product-set="Red Hat Virtualization" \
         --flags=rhevm-${release}-ga?,rhevm-${release}-ga+,ovirt-${release}?,ovirt-${release}+ \
         --file=topics/ref-ovirt-${release}-beta.adoc --milestones=${milestones} \
         --releases= --verbose --force --section --asciidoc --include-all --next \
         --title="Red Hat Virtualization ${release}-Beta"

if [ ! -f topics/ref-ovirt-${release}-beta.adoc ]
then
  echo -e "\nRunning the \e[1mrelnotes\e[0m tool failed. Exiting." >&2
  exit 1
fi

echo -e "Updating the \e[1m$MASTER\e[0m file.\n"

cat >> $MASTER <<EOF

include::topics/ref-ovirt-${release}-beta.adoc[]

EOF

echo "Done."
