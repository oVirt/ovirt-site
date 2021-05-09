---
title: Users list
authors: didib
page_classes: community
no_container: true
---

# Users list

The [users mailing list](https://lists.ovirt.org/archives/list/users@ovirt.org/) is the main place for getting help, asking questions, consulting about design/hardware/configuration/performance etc., and of course sharing your experience.

## Getting help

TL;DR: When asking for help, please provide: what you did, versions of packages used, content of `/var/log/*ovirt*` and `/var/log/vdsm/*` . Thanks!

To post to this list, send your email to:

  users@ovirt.org

TODO: Either mention that the list is currently open to non-subscribers but do recommend to subscribe, or, if/when we decide to block posts for non-subscribers, mention that.

When requesting help for fixing a problem, please provide enough information to help understand the issue at once - spending time asking for more information is not effective, for both you and the other subscribers:

* The exact sequence of events/actions leading to the issue
* Content of relevant log files. For the engine, this often includes `/var/log/ovirt-engine/*`, including subdirectories and all files within
* Other `/var/log/*ovirt*` directories/files, as applicable (e.g. ovirt-engine-dwh for dwh-related issues)
* /var/log/messages and the output of ‘journalctl’
* The exact time the problem happened. Sometimes you can’t know that, but in others you do - you installed something, pressed some button, and got an error. In this case, if, before you pressed this button, you also pressed many other buttons and got many other error messages (and even if you did not), there are likely other errors in the logs, some of which are irrelevant - and noone wants to spend time analyzing them.
* Versions of relevant packages - e.g. the output of ‘rpm -q ovirt-engine vdsm’ etc.

Thank you!

