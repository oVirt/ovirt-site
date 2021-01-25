---
title: Otopi
authors: didi
---

# Otopi

## OTOPI

OTOPI's "home page": <http://gerrit.ovirt.org/gitweb?p=otopi.git;a=blob;f=README;hb=HEAD>

A nice presentation about OTOPI and ovirt-host-deploy (the first tool to use otopi): <http://resources.ovirt.org/old-site-files/wiki/Ovirt-host-deploy_3.2.pdf>. ovirt-host-deploy is now not in use anymore, and its functionality was rewritten in ansible.

### Environment

OTOPI maintains an Environment - key-value-pair store of data and configuration.

Some of these keys can be used to affect/configure otopi-based tools by setting them outside of the default interaction with the user:

*   By adding a configuration file to a relevant TOOL.d directory, where applicable

    E.g. engine-setup reads `/etc/ovirt-engine-setup.conf.d/*.conf`, so you can add there a file with answers to questions you do not want to be asked about

*   By passing a command-line option which directly adds a pair to the environment

    E.g. engine-setup accepts '--otopi-environment' so you can do e.g.
    `engine-setup --otopi-environment='OVESETUP_SYSTEM/memCheckEnabled=bool:False'` to not be asked about too-low-memory.

*   By passing an option to load a configuration file (instead of the TOOL.d/\*.conf files or in addition to them)
*   Some tools create, when ran, a configuration file with answers to all the questions asked during the run.

    These files can be used with the options above. E.g. if running 'engine-setup' emits, during the end:

```
[ INFO ] Generating answer file '/var/lib/ovirt-engine/setup/answers/20130901173707-setup.conf'
```

    You can copy this file either to /etc/ovirt-engine-setup.conf.d where it will be read automatically by further runs, or to /my/conf/path/my-answers.conf and then use it with engine-setup --config=/my/conf/path/my-answers.conf .

Important note: Such options/conf files override code which might not have been ran at all if only dialog interaction was used. E.g. a first clean setup with the allinone plugin installed, during which we chose to "Configure VDSM on this host", will create a file /etc/ovirt-engine-setup.conf.d/20-setup-aio.conf which disables this plugin on further runs of engine-setup (used for upgrades). If we add in /etc/ovirt-engine-setup.conf.d our own file with the content [environment:default] OVESETUP_AIO/enable=bool:True then this plugin will be activated on all subsequent runs of engine-setup, and might cause problems by trying to configure VDSM on our already configured host.

### Logs

otopi creates log files that are rather easy to understand, if you know how to read them :-). It starts by creating a sequence of methods (called "events") it is going to run, and then it runs them one after the other. Before running each such method, it writes to the log something like:
```
2018-07-02 07:29:07,127+0000 DEBUG otopi.context context._executeMethod:128 Stage boot METHOD otopi.plugins.otopi.dialog.human.Plugin._init
```

Each method has a condition, and if the condition evaluated to False, otopi will not run it, and write to the log something like:
```
2018-07-02 07:29:07,131+0000 DEBUG otopi.context context._executeMethod:135 condition False
```

Output that went also to the terminal is also logged, e.g.:
```
2018-07-02 07:29:07,458+0000 INFO otopi.context context.runSequence:741 Stage: Initializing
```

or:
```
2018-07-02 07:29:07,679+0000 WARNING otopi.plugins.otopi.network.hostname hostname._validation:61 Cannot validate host name settings, reason: Command 'ip' not found
```

or:
```
2018-07-02 07:29:07,696+0000 DEBUG otopi.plugins.otopi.dialog.human dialog.__logString:204 DIALOG:SEND                
2018-07-02 07:29:07,697+0000 DEBUG otopi.plugins.otopi.dialog.human dialog.__logString:204 DIALOG:SEND                 Calling install on zziplib:
```

Methods can add to the log information at DEBUG level - this is not output to the terminal. E.g.:
```
2018-07-02 07:29:07,122+0000 DEBUG otopi.context context._executeMethod:128 Stage boot METHOD otopi.plugins.otopi.system.info.Plugin._init
2018-07-02 07:29:07,122+0000 DEBUG otopi.plugins.otopi.system.info info._init:39 SYSTEM INFORMATION - BEGIN
2018-07-02 07:29:07,122+0000 DEBUG otopi.plugins.otopi.system.info info._init:40 executable /bin/python3
2018-07-02 07:29:07,123+0000 DEBUG otopi.plugins.otopi.system.info info._init:41 python version 3.6.5 (default, Mar 29 2018, 18:20:46) 
[GCC 8.0.1 20180317 (Red Hat 8.0.1-0.19)]
2018-07-02 07:29:07,123+0000 DEBUG otopi.plugins.otopi.system.info info._init:42 python /bin/python3
2018-07-02 07:29:07,123+0000 DEBUG otopi.plugins.otopi.system.info info._init:43 platform linux
2018-07-02 07:29:07,125+0000 DEBUG otopi.plugins.otopi.system.info info._init:44 distribution ('Fedora', '28', 'Twenty Eight')
2018-07-02 07:29:07,126+0000 DEBUG otopi.plugins.otopi.system.info info._init:45 host 'vm0135.workers-phx.ovirt.org'
2018-07-02 07:29:07,126+0000 DEBUG otopi.plugins.otopi.system.info info._init:51 uid 0 euid 0 gid 0 egid 0
2018-07-02 07:29:07,126+0000 DEBUG otopi.plugins.otopi.system.info info._init:53 SYSTEM INFORMATION - END
```

After the method finished, if it changed the environment, otopi will add to the log a list of the keys that changed and their values, e.g.:
```
2018-07-02 07:29:07,127+0000 DEBUG otopi.context context._executeMethod:128 Stage boot METHOD otopi.plugins.otopi.dialog.human.Plugin._init
2018-07-02 07:29:07,129+0000 DEBUG otopi.context context.dumpEnvironment:859 ENVIRONMENT DUMP - BEGIN
2018-07-02 07:29:07,129+0000 DEBUG otopi.context context.dumpEnvironment:869 ENV DIALOG/autoAcceptDefault=bool:'False'
2018-07-02 07:29:07,130+0000 DEBUG otopi.context context.dumpEnvironment:869 ENV DIALOG/boundary=str:'--=451b80dc-996f-432e-9e4f-2b29ef6d1141=--'
2018-07-02 07:29:07,130+0000 DEBUG otopi.context context.dumpEnvironment:873 ENVIRONMENT DUMP - END
```

If otopi decided to give up and rollback, it will change the env key 'BASE/error' to True, and the reason for the failure, hopefully with more relevant details, can usually be found around a set of lines like these:
```
2018-07-02 07:29:07,755+0000 DEBUG otopi.context context.dumpEnvironment:859 ENVIRONMENT DUMP - BEGIN
2018-07-02 07:29:07,755+0000 DEBUG otopi.context context.dumpEnvironment:869 ENV BASE/error=bool:'True'
2018-07-02 07:29:07,755+0000 DEBUG otopi.context context.dumpEnvironment:869 ENV BASE/exceptionInfo=list:'[(<class 'NotImplementedError'>, NotImplementedError('Packager install not implemented',), <traceback object at 0x7f08e8af7788>)]'
2018-07-02 07:29:07,757+0000 DEBUG otopi.context context.dumpEnvironment:873 ENVIRONMENT DUMP - END
```

Often, right before that, a stack trace is logged, showing the exact location in the code that failed. Such s trace starts with `Traceback`, but not every occurrence of `Traceback` is a problem - some places in the code try something, get an exception, handle it, including logging the traceback, but do not fail. So a reliable way to find the correct place that failed is seraching for `BASE/error=bool:'True'`.

### Users

otopi most probably has no humans using it directly. Although technically you can run 'otopi' and see it do a bit of stuff, and even more than a bit if you pass some env vars, otopi should be considered a kind of "library". Other tools use it, usually by supplying extra plugins implementing the actual functionality they are meant to provide and a wrapper that is calling otopi with the needed plugins.

Following is a list of projects/tools that are using otopi or are related to it:

* ovirt-host-deploy (Not in use in 4.4+; re-implemented in ansible)

* Inside ovirt-engine: engine-setup, engine-cleanup, ovirt-engine-rename, ovirt-engine-provisiondb, ovirt-engine-health

* Inside ovirt-dwh: plugins for engine-setup/cleanup/etc.

* Inside ovirt-imageio: plugins for engine-setup/cleanup/etc.

* rhvm-setup-plugins: plugins for engine-setup/cleanup/etc. (in RHV, not part of oVirt)

* ovirt-hosted-engine-setup

* Inside ovirt-engine-extension-aaa-ldap: ovirt-engine-extension-aaa-ldap-setup

