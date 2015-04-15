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

### Release Notes

      == Your feature heading ==
      Cinder and Glance integration via Docker

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to <Talk:CinderGlance_Docker_Integration>

<Category:Feature> <Category:Template>
