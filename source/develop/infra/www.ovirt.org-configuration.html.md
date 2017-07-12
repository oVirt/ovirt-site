---
title: Www.ovirt.org-Configuration
category: infra
authors: dneary, quaid
---

# Www.ovirt.org-Configuration

This page explains how www.ovirt.org is generally configured.

## OpenShift running MediaWiki

Our primary website is a MediaWiki instance running a customized version of the Strapping theme, running on top of several gears at OpenShift.

*   A PHP 5.3 gear running the MediaWiki code
*   A MySQL 5.x gear running the MediaWiki database

### Details

*   Server name: www.ovirt.org or wiki-ovirt.rhcloud.com
*   User: you should have a user with key. Please contact Karsten Wade to have your OpenShift account added as a co-manager of the app, or to have a public key added to enable you to connect remotely
*   Environment variables:
    -   $OPENSHIFT_PHP_LOG_DIR points to the apache logs,
    -   $OPENSHIFT_DATA_DIR points to the persistent data, such as our mediawiki image uploads
    -   $OPENSHIFT_MYSQL_DB_LOG_DIR for the mysql
    -   env is a very useful command on openshift.

## Troubleshooting

Typical (thankfully not frequent) problems include slow response time, the server not responding at all, or issues related to the database being blocked. The most frequent issue is a full disk quota.

### Full disk quota

Symptom: The site will stop working

Treatment:

1.  SSH into gear
2.  Confirm quota issue with quota -s
3.  cd into php/logs
4.  Compress any uncompressed log files.
5.  Delete old error logs (or transfer them to another host)
6.  Restart app with command "ctl_app restart"

### Database blockage

1.  Verify that the disk quota is not full
2.  Report issue to OpenShift to allow them to investigate (#openshift on freenode)
3.  Restart app with command "ctl_app restart"

### Server down or very slow

Occasionally, the site has slowed dramatically due to a gear on the same host (potentially ours) doing a lot of disk I/O. On circumstances like this, sometimes parts of a page will load while others will time out, and in the past, a restart has not been sufficient to get things to a normal state.

1.  Try to restart the app first, either by removing .openshift/markers/hot_deploy from your copy of the site source code, and pushing the result, or by running ctl_app restart on the openshift gear
2.  If this does not work, then contact the OpenShift admins on #openshift on freenode, or (if you are with Red Hat) on the internal OpenShift Operators IRC channel #libra-ops - only an OpenShift operator can diagnose and clear up the problem.

### How to check if disk is full

Disk is limited by standard quotas:

    [wiki-ovirt.rhcloud.com 847edb45aea84198838f915be6faa066]> quota -s
    Disk quotas for user 847edb45aea84198838f915be6faa066 (uid 3689):
         Filesystem  blocks   quota   limit   grace   files   quota   limit   grace /dev/mapper/EBSStore01-user_home01
                      4911M       0   5120M            9571       0    200k

The first figure is the occupied blocks, the third is the upper limit, the fourth is the number of files and the sixth is the upper limit for that. We can see that we are using 4911M blocks of a quota of 5120M - over 98% of capacity.

## Administrators

These are people with the keys and skills to administrate, troubleshoot, and fix this system:

*   [Dave Neary](DNeary)
*   [Garrett Lesage](Garrett)
*   [Karsten Wade](Quaid)
*   [Jason Brooks](Jbrooks)

[Category:Infrastructure documentation](/develop/infra/infrastructure-documentation/) <Category:Wordpress>
