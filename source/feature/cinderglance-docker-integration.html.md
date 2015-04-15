---
title: CinderGlance Docker Integration
category: feature
authors: sandrobonazzola, stirabos
wiki_category: Feature|CinderGlance Docker Integration
wiki_title: CinderGlance Docker Integration
wiki_revision_count: 11
wiki_last_updated: 2015-05-06
feature_name: Cinder and Glance integration via Docker
feature_modules: engine
feature_status: Developement
---

# CinderGlance Docker Integration

Cinder and Glance integration via Docker

## Your Feature Name

### Summary

The use of Docker containers make easier to locally deploy Cinder and Glance on the engine host. We are going to use docker images from kollaglue project: kollaglue is the official effort to deploy openstack components via docker.

### Owner

This should link to your home wiki page so we know who you are

*   Name: [ Simone Tiraboschi](User:stirabos)

Include you email address that you can be reached should people want to contact you about helping with your feature, status is requested, or technical issues need to be resolved

*   Email: <stirabos@redhat.com>

### Detailed Description

The aim of this feature is to let the user simply deploy and configure cinder and glance within the engine from engine-setup.

To avoid any new strong dependency a new engine-setup plugin will be developed. Installing that plugin from its rm and running engine-setup the user will be able to pull the right docker containers, configure them and configure them as external providers within the engine.

### Benefit to oVirt

The user will be able to locally run glance to import and store VM images and cinder to access external volumes. Deploying them as docker images makes it more easier to be accomplished without the need for a manual complex configuration.

### Dependencies / Related Features

glance could be already used as an external provider from the engine, cinder integraton still require more effort on backend side: <http://www.ovirt.org/Features/Cinder_Integration>

### Documentation / External references

Upstream information about kollaglue could be found there: <https://github.com/stackforge/kolla/>

glance requires two distinct containers:

      kollaglue/centos-rdo-glance-registry:latest
      kollaglue/centos-rdo-glance-api:latest

cinder one:

      kollaglue/centos-rdo-cinder:latest

both of them requires additional containers:

      kollaglue/centos-rdo-rabbitmq:latest
      kollaglue/centos-rdo-mariadb-data:latest
      kollaglue/centos-rdo-mariadb-app:latest
      kollaglue/centos-rdo-keystone:latest

### Testing

Install the plugin rpm

      yum install ovirt-engine-setup-plugin-dockerc

Run engine setup

      engine-setup

Choose to deploy cinder and glance

               Deploy Cinder container on this host (Yes, No) [No]: yes
               Deploy Glance container on this host (Yes, No) [No]: yes

It should deploy and start all the required containers

      [ INFO  ] Starting Docker
      [ INFO  ] Pulling rabbitmq
      [ INFO  ] Pulling mariadbdata
      [ INFO  ] Pulling mariadbapp
      [ INFO  ] Pulling keystone
      [ INFO  ] Pulling cinder
      [ INFO  ] Pulling glance-registry
      [ INFO  ] Pulling glance-api
      [ INFO  ] Creating rabbitmq
      [ INFO  ] Starting rabbitmq
      [ INFO  ] Creating mariadbdata
      [ INFO  ] Starting mariadbdata
      [ INFO  ] Creating mariadbapp
      [ INFO  ] Starting mariadbapp
      [ INFO  ] Creating keystone
      [ INFO  ] Starting keystone
      [ INFO  ] Creating cinder
      [ INFO  ] Starting cinder
      [ INFO  ] Creating glance-registry
      [ INFO  ] Starting glance-registry
      [ INFO  ] Creating glance-api
      [ INFO  ] Starting glance-api

When the setup completes you could check the status of the containers with:

      [root@c7t1 ~]# docker ps -a
      CONTAINER ID        IMAGE                                         COMMAND                CREATED             STATUS                               PORTS               NAMES
      ed3c0510e0d8        kollaglue/centos-rdo-glance-api:latest        "/start.sh"            4 hours ago         Up 4 hours                                               glance-api          
      0bc3674d9b63        kollaglue/centos-rdo-glance-registry:latest   "/start.sh"            4 hours ago         Up 4 hours                                               glance-registry     
      31cea8df4547        kollaglue/centos-rdo-cinder:latest            "/start.sh"            4 hours ago         Restarting (127) About an hour ago                       cinder              
      1b703e42a671        kollaglue/centos-rdo-keystone:latest          "/start.sh"            4 hours ago         Up 4 hours                                               keystone            
      cf2e262f74c1        kollaglue/centos-rdo-mariadb-app:latest       "/opt/kolla/mysql-en   4 hours ago         Up 4 hours                                               mariadbapp          
      026018f2e8e2        kollaglue/centos-rdo-mariadb-data:latest      "/bin/sh"              4 hours ago         Restarting (0) About an hour ago                         mariadbdata         
      5522df92da33        kollaglue/centos-rdo-rabbitmq:latest          "/start.sh"            4 hours ago         Up 4 hours                                               rabbitmq 

You could check the logs of a specific container with

### Release Notes

      == Your feature heading ==
      Cinder and Glance integration via Docker

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to <Talk:CinderGlance_Docker_Integration>

<Category:Feature> <Category:Template>
