---
title: Otopi
authors: didi
---

# Otopi

## OTOPI

Need to add somewhere documentation about otopi and the tools using it. Not sure this is the right place - possible other places are tool-specific page and/or manpages.

OTOPI's "home page": <http://gerrit.ovirt.org/gitweb?p=otopi.git;a=blob;f=README;hb=HEAD>

A nice presentation about OTOPI and host-deploy-engine (the first tool to use otopi): <http://resources.ovirt.org/old-site-files/wiki/Ovirt-host-deploy_3.2.pdf>

### Environment

OTOPI maintains an Environment - key-value-pair store of data and configuration.

Some of these keys can be used to affect/configure otopi-based tools by setting them outside of the default interaction with the user:

*   By adding a configuration file to a relevant TOOL.d directory, where applicable

       E.g. engine-setup reads /etc/ovirt-engine-setup.conf.d/*.conf, so you can add there a file with answers to questions you do not want to be asked about

*   By passing a command-line option which directly adds a pair to the environment

       E.g. engine-setup accepts '--otopi-environment' so you can do e.g.
       engine-setup --otopi-environment='OVESETUP_SYSTEM/memCheckEnabled=bool:False' to not be asked about too-low-memory

*   By passing an option to load a configuration file (instead of the TOOL.d/\*.conf files or in addition to them)
*   Some tools create, when ran, a configuration file with answers to all the questions asked during the run.

       These files can be used with the options above. E.g. if running 'engine-setup' emits, during the end:

[ INFO ] Generating answer file '/var/lib/ovirt-engine/setup/answers/20130901173707-setup.conf' You can copy this file either to /etc/ovirt-engine-setup.conf.d where it will be read automatically by further runs, or to /my/conf/path/my-answers.conf and then use it with engine-setup --config=/my/conf/path/my-answers.conf

Important note: Such options/conf files override code which might not have been ran at all if only dialog interaction was used. E.g. a first clean setup with the allinone plugin installed, during which we chose to "Configure VDSM on this host", will create a file /etc/ovirt-engine-setup.conf.d/20-setup-aio.conf which disables this plugin on further runs of engine-setup (used for upgrades). If we add in /etc/ovirt-engine-setup.conf.d our own file with the content [environment:default] OVESETUP_AIO/enable=bool:True then this plugin will be activated on all subsequent runs of engine-setup, and might cause problems by trying to configure VDSM on our already configured host.
