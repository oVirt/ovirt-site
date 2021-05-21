---
title: Jenkins-Migration-Plan
category: infra
authors:
  - eedri
  - ekohl
---

# Jenkins-Migration-Plan

The following is a migration plan for [jenkins.ovirt.org](https://jenkins.ovirt.org/) to a new physical server.

## prior testing: (before we have access to servers)

1.  prior testing phase - test on new server before starting migration
2.  creating puppet classes for installing the jenkins master server + configuration (plugins, permissions, etc...)
3.  verify testing phase (managed to install jenkis master via foreman+puppet)
4.  add puppet classes to manage slaves
5.  setup openid as authentication for server via puppet class
6.  test project role auth matrix, to restrict certain users to certain views/projects

## install jenkins master server via exiting foreman (LTS)

1.  contacting alterway for root access to new servers.
2.  make sure to install all existing plugins from jenkins.ovirt.org
3.  enable apache server redirect port 8080
4.  verification stage: new server is running and accesible via ip x.x.x.x

## copy jenkins user ssh key to new server -> to allow connection to services

1.  test gerrit access from new server
2.  test resources server (linode) access via ssh

## add all existing slaves to foreman

1.  adding one by one, defining new hostgroup for each operating system.

**----- till now no affect to exiting service or downtime -----**

## migration plan

1.  copy main configuration file (config.xml)
2.  disable slaves so jenkins.ovirt.org will continue running.
3.  add the 2nd phsical server as temp slave for testing
4.  copy jobs configuration (tar.gz of current jobs dir)
5.  copy builds (tar.gz and move it)
6.  copy user database (since it's a small user db, we might want to recreate them using openid)
7.  copy other imporant files (userContent?)
8.  verify jobs
9.  detach existing slaves from jenkins.ovirt.org to new server
10. change dns entry for new server to jenkins.ovirt.org and old server to jenkins-test.ovirt.org
11. verify all jobs works

        * gerrit access

        * linode access

