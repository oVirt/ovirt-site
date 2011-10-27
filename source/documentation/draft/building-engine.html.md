---
title: Building oVirt engine
category: draft-documentation
authors: abonas, alonbl, amuller, amureini, apevec, asaf, djorm, dneary, doron, dougsland,
  gwei3, ichristo, jhernand, jumper45, laravot, lhornyak, lpeer, mbetak, mburns, moolit,
  moti, ofrenkel, ovedo, quaid, rmiddle, sgordon, sgtpepper, shireesh, vered, yair
  zaslavsky, ykaul
wiki_category: Draft documentation
wiki_title: Building oVirt engine
wiki_revision_count: 237
wiki_last_updated: 2013-06-25
---

# Building oVirt engine

 <<TableOfContents(3)>>

This wiki page walk you through the steps required in order to setup an oVirt development environment on Fedora 14+.

## Pre Requirements

1.  Fedora 14 and up x86-64 OS
2.  Internet connection

## Installing JDK

OpenJDK

*   Verify that javac linked to openjdk-1.6.0's javac properly.

**Or** SUN JDK

## Installing JBoss AS

You can install the RPM -

??? missing RPM details ???

OR -

Download and copy to /usr/local/

Check that it runs:

Some useful JAVA_OPTS:

      * -Xmx512m - maximum Java heap size of 512m
      * -Xdebug - include debugging
      * Run with `` to have it bind to all IP addresses; by default it just binds to `` i.e.<
      > 
      * Make sure you've nothing bound to port `` or 
      * Add another host to your /etc/hosts file. i.e. <
      > `` <
      > Where user.ovirt.org is the hostname that JBoss tried to look up upon starting the server.

## Installing tools

### Installing git

oVirt-engine's SCM is Git, following are the minimal instructions how to setup git for oVirt, we can install git and other tools using yum:

These tools are packages and normally installed in base Fedora install.

### Installing maven

oVirt is managed by maven version 2.2.x, maven 3.x will not work. <
> For Fedora 14/15 this is the default, use:

For other versions you can download & Install maven:

#### Add Maven to Path

#### Maven personal settings

Copy paste the content of the file below into ~/.m2/settings.xml

*   'Do not omit the active-profiles element in the above xml, it is crucial.'

## Installing PostgreSQL

### Installing PostgreSQL and dependencies

On your linux machine run the following commands:

### Installing a special patch fixing rowtype mismatch on column deletion (needed only for fedora 14)

Skip this step if you are using PostgreSQL 8.4.8 or later. Check your version with

This patch is still not available via yum update and you must follow this procedure:

### Runing the service

 It is recommended to add this service to auto start by

### Connecting to the database

You should set security definitions in hba_conf file as described at <
> <http://www.postgresql.org/docs/8.2/interactive/auth-pg-hba-conf.html>

Edit /var/lib/pgsql/data/pg_hba.conf' ''and set authentication parameters as follows: ''

 Run /etc/init.d/postgresql restart

### Setup PostgreSQL UUID support

PostgreSQL 8.4 does not install uuid generation functions by default. In order to use those functions, you will have to install it manually, by running:

The package installation distributes a library named uuid-ossp.so

      (on Fedora 14 64 bit its in /usr/lib64/pgsql/uuid-ossp.so)

The added functions are documented at <
> <http://www.postgresql.org/docs/8.3/static/uuid-ossp.html>

You can run those function from pgsql , for example:<
>

### Connecting from other hosts

If you want to be able to connect to PostgreSQL from other hosts (i.e. not from localhost only) do the following:

## oVirt-engine Source

### Clone oVirt-engine codebase

Choose a directory where you want to keep oVirt sources and 'cd' to it Then you can clone:

Let $OVIRT_HOME be <your_chosen_source_location>/engine.oss

### Creating the database

In your git repository, run the following command

### Build

If you want only virt-engine-core and rest api:

For compiling the webadmin and user portal in addition to the api and engine use:

      * Compiling the webadmin and userportal takes (a long) time.
      * Make sure to run this with your user, not 'root'. if you run as root maven will look for settings.xml in the home directory of 'root', and since no such file exists there maven won't find the property '$jbossHome' and will fail to copy resources.

### deploy

      * For the first deploy of the application to JBoss AS container use the setup profile:

*   After first deploy use:

## Testing

Use username **admin@internal** and password **letmein!**

Accessing the RESTful API:

 or from the browser

Accessing the web-admin: <
>

Accessing the user-portal <
>

## System Configuration

      Fedora configuration.

### Configure Firewall - optional

Configure individual ports or just turn it off:

### Configure SELinux - optional

Log in as root and edit /etc/selinux/config set SELINUX=permissive

### Configure git user & email - optional

## Gerrit

1. registering as a user: - you can use any OpenID provider for now[1] - login page shows google and yahoo - any fedora FAS account can login as well via <https://admin.fedoraproject.org/accounts/openid/id/>&lt;username&gt;

2. set ssh keys in gerrit settings - on your local machine, create a set of ssh keys if you don't have one via 'ssh-keygen -t rsa' - update via gerrit settings the ssh public key to allow ssh to gerrit

3. define gerrit in ~/.ssh/config Host gerrit.ovirt.org

        HostName gerrit.ovirt.org
        Port 29418
`  User `&lt;username&gt;

4. check ssh works correctly, verify and ack the host fingerprint: ssh gerrit.ovirt.org

if you get this, it is fine:

*   -   Welcome to Gerrit Code Review \*\*\*\*

5. cloning the repo git clone gerrit.ovirt.org:ovirt-engine

this can be done without registering to gerrit using: git clone <git://gerrit.ovirt.org/ovirt-engine>

6. install the change-Id hook - you must do this before you commit anything: scp -p gerrit.ovirt.org:hooks/commit-msg .git/hooks/

7. do some work/commit/etc. wiki link on how to build/run ovirt will be sent shortly

8. rebase: git fetch gerrit.ovirt.org:ovirt-engine master

9. push your patch for review: git push gerrit.ovirt.org:ovirt-engine HEAD:refs/for/master

10. track patch review process the review process is comprised of: - anyone can send a patch - anyone can code review and comment on the patch and +1/-1. This helps maintainers in reviewing the patches. - a maintainer can code review it with +2 it, which is required to commit (submit) it. - someone (anyone) needs to confirm they checked the patch works and flag it as verified +1 - a maintainer can submit (commit) the patch when it has:

        Code Review: +2
        Verified: +1

* nacked (-1) patches should not be submitted - a submitted patch is merged to the git

[1] if anyone provides a reason to limit to specific OpenID providers that's an option as well.
