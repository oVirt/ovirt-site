---
title: Infrastructure team task list
category: infra
authors: dneary, quaid, rmiddle
---

# Infrastructure team task list

## One time tasks

*   <s>Resize Linode disk, reboot server</s> - (quaid) Completed 7/13/2012
*   <s>break out media wiki from www.ovirt.org</s> (rmiddle) Completed 7/13/2012
*   Upgrade WordPress
*   Check for other upgrades (\*EL, EPEL)
*   Proposal for migrating services to OpenShift - (quaid)
*   Publican for docs.ovirt.org (using OpenShift?)
*   Puppet server for all of Infra needs
*   Move Jenkins from EC2 to dedicated host for performance and cost benefits
*   Fill out Design of oVirt project infrastructure
*   Add true night repo's (rmiddle & eedri)
*   Extend vdsm's on-commit hook, so it runs functional tests too. This requires installing vdsm.rpm as well as vdsm-tests.rpm, starting vdsmd service, running the tests, and cleaning the host.
*   <s>Add log rotate for Jenkins slave logs.</s> - (rmiddle) Completed 7/24/2012
*   <s>Add automatic backups of Jenkins data from Master.</s> - (rmiddle) Completed 7/25/2012

## Ongoing tasks

*   Running multiple services:
    -   WordPress
        -   Backing up database.
    -   MediaWiki
        -   Backing up database.
    -   MeetBot
    -   Jenkins
        -   Daily backups of the config.
    -   Gerritt
    -   Mailman
        -   Making a new mailing list
        -   Providing information about a mailing list
    -   MySQL
*   Services upgrades
*   DNS requests
*   [Adding a new system administrator to a host](/develop/infra/adding-a-new-system-administrator-to-a-host.html)

## Standard procedures

Standard procedures for performing any one-time or ongoing tasks are found in [Infrastructure documentation](/develop/infra/infrastructure-documentation.html).

