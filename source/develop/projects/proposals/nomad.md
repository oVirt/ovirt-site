---
title: Project Proposal - Nomad
category: project-proposal
authors: ichristo, quaid
wiki_category: Project proposal
wiki_title: Project Proposal - Nomad
wiki_revision_count: 6
wiki_last_updated: 2011-10-19
---

# Project Proposal - Nomad

## Nomad - the Mobile Manager for oVirt

## Abstract

Nomad will be a mobile application for the oVirt project that can run on iPhone, iPad, and Android devices.

## Proposal

Nomad will be a mobile application that interfaces with the oVirt REST API, which is based on the RHEVM-API, to provide administrators a way to manage the oVirt infrastructure without having to login via remote desktops. Nomad will initially be targeted to administrators who need to perform basic management functionality such as Host restarts, VM start|stop|restarts, as well as, viewing overall system health.

## Background

RHEV 2.2 currently provides a web based client interface that is only accessible via Internet Explorer on Windows. Nomad was developed internally to provide the ability for basic administration of our development infrastructure. As many of our administrators are typically offsite, remotely accessing the administrative tools is not always a convenient option. To improve responsiveness, a mobile application was developed that can run on android devices.

## Rationale

Tablets and Smartphones are quickly becoming the platform of choice and are the primary way that we interact with the internet. There is a clear need for the ability to interface with critical systems infrastructure using our smartphones and tablets.

## Initial Goals

The initial goal is to provide the ability to remotely access oVirt/RHEV and retrieve overall summary information to include host status, virtual machine status, and alerts. As the project matures, the ability to manage virtual machines, hosts, and storage will be added to provide a feature-rich mobile client.

## Current Status

Proof of concept has been developed internally for android devices. The next iteration will incorporate iPhone and iPad devices.

## oVirt Infrastructure

*   Bugzilla
*   Mailing list: devel

## External Dependencies

*   RHEVM/oVirt REST API - Nomad is a remote client to oVirt and consumes the REST API to interact with the core engine.
*   Appcelerator Titanium Framework - An Apache-Licensed Framework for developing mobile application frameworks

## Initial Committers

*   Isaac Christoffersen (ichristoffersen at vizuri dot com)
*   Ken Spokas (kspokas at vizuri dot com)

[Category:Project proposal](Category:Project proposal) <Category:Nomad>
