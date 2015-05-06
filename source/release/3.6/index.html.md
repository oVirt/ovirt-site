---
title: OVirt 3.6 Release Notes
category: documentation
authors: didi, mperina, sandrobonazzola
wiki_category: Documentation
wiki_title: OVirt 3.6 Release Notes
wiki_revision_count: 34
wiki_last_updated: 2015-05-22
---

DRAFT DRAFT DRAFT

oVirt is an open source alternative to VMware vSphere, and provides an excellent KVM management interface for multi-node virtualization.

# oVirt 3.6.0 ALPHA Release Notes

### ALPHA RELEASE

The oVirt Project is working on oVirt 3.6.0 Alpha release

### Known Issues

*   The engine fails with openjdk 1.8. Until this is fixed, workaround is to install java-1.7.0-openjdk, and make it default with update-alternatives, or just remove java-1.8.0-openjdk.
*   This means that the engine is not supported on Fedora >= 21 (which does not have java-1.7.0-openjdk).

# Install / Upgrade from previous versions

### ALPHA RELEASE

The oVirt Project is working on oVirt 3.6.0 Alpha release.

# CVE Fixed

# <span class="mw-customtoggle-1" style="font-size:small; display:inline-block; float:right;"><span class="mw-customtoggletext">[Click to Show/Hide]</span></span>Bugs Fixed

<div  id="mw-customcollapsible-1" class="mw-collapsible mw-collapsed">
### oVirt Engine

### oVirt Hosted Engine Setup

* [RFE] Possibility to install host into engine VM without running through the whole installation process again.
 - [RFE] Hosted Engine on FC
 - [RFE][HC] make override of iptables configurable when using hosted-engine
 - [HE-setup] Use vdsm api instead of vdsClient
 - [RFE] Prompt again for admin password during hosted-engine --deploy
 - hosted engine setup doesn't detect volume creation failures
 - [RFE] refactor VM startup code using VDSM API and don't try to set ticket until VM is up
 - Running hosted-engine --vm-status, when ovirt-ha-broker service stopped, drop exception
 - [RFE] Hosted Engine on FC
 - [hosted-engine] [iSCSI support] connectStoragePools fails with "SSLError: The read operation timed out" while adding a new host to the setup
 - [hosted-engine] Bad check of iso image permission
 - vdsClient/vdscli SSLError timeout error
 - [RFE][HC] - Hosted Engine Support for GlusterFS
 - [RFE][HC] - Hosted Engine Support for Hyper Converged GlusterFS
 - [RFE] [hosted-engine-setup] [iSCSI support] Add more information to LUNs list provided during deployment
 - [RFE] Add the capability to attach an ISO image for cloud-init configuration
 - Validate the required number of CPU for the VM before trying to start it
 - engine VM doesn't start deploying from disk or appliance
 - [TEXT ONLY] - Hosted Engine - Instructions for handling Invalid Storage Domain error
 - [RFE] Let the user customize rhevm appliance memory size from deployment scripts
 - [HC] hosted-engine --deploy fails on additional host with external glusterfs

### oVirt Hosted Engine HA

* Log entries should explain why HE agent try to start vms on both hosts
 - Unexpected Migration of HostedEngine
 - ovirt-hosted-engine-ha rpm should depend on otopi
 - bogus line during installer boot

### oVirt Log Collector

* [RFE] Log collector does not collect hosted engine information
 - log-collector tar files change "." permissions when extracted
 - [RFE] log collector should collect engine-config settings and domain information
 - split rhevm-log-collector moving sos plugins to subpackage

### oVirt Image Uploader

* [RFE] add progress bar to image uploader

### oVirt ISO Uploader

* [RFE] add progress bar to image uploader
 - [engine-iso-uploader] engine-iso-uploader does not work with Local ISO domain

### oVirt Live

* [RFE] Enable the configuration of the SANWipeAfterDelete property in the setup
 - [RFE] Rebase oVirt Live on CentOS 7.z

<Category:Documentation> <Category:Releases>
