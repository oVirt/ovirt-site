---
title: Installing ovirt-engine from rpm
authors: aglitke, djorm, dougsland, mburns, moti, oschreib, ranglust, sandrobonazzola,
  sgordon
---

This Documents has come to describe the steps required in order to install & configure ovirt-engine Use this guide in order to install VDSM on the same host as ovirt-engine: [Installing_VDSM_from_rpm](/develop/developer-guide/vdsm/installing-vdsm-from-rpm/)

## Installing oVirt Release rpms configuring oVirt's repositories

Go to the following address:

[`http://resources.ovirt.org/pub/yum-repo/`](http://resources.ovirt.org/pub/yum-repo/)

and select the release you want to install. You can find more info in the [README](http://resources.ovirt.org/pub/yum-repo/README) file

Once you've decided which release you want to install, use yum for installing it (remember to use the URL of the RPM you selected)

`yum -y install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm)

For nighlty snapshot please refer to [Install nightly snapshot](/develop/dev-process/install-nightly-snapshot/) documentation.

# oVirt Engine

## Installing & Configuring ovirt-engine

### Cleanup

If you're installing on a clean system you can skip this step.

**Before every re-installation**, you should run the cleanup utility:

      engine-cleanup
       

### Install

Install ovirt-engine by executing:

      yum -y install ovirt-engine
       

and execute the installation utility:

      engine-setup
       

### Additional Configuration

<big>**WARNING: THIS PARAGRAPH MAY BE OBSOLETE, NEED VERIFICATION ON LATEST RELEASES**</big>

If you wish to turn off secured connection to the hosts:

      psql -U postgres engine -c "update vdc_options set option_value='false' where option_name='UseSecureConnectionWithServers' and version='general';"
       

If you issued the above command, you should also submit the following command to work around ovirt-engine bug 784348:

      psql -U postgres engine -c "update vdc_options set option_value='' where option_name = 'SpiceSecureChannels';"
       

### JBoss AS Security

We currently use a customize rpm wrapping JBoss AS 7.1.1
