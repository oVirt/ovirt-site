---
title: GuestAgent
authors: nkesick, vfeenstr, zhshzhou
wiki_title: Ubuntu/GuestAgent
wiki_revision_count: 10
wiki_last_updated: 2014-10-05
---

[Back to Ubuntu MainPage](Ubuntu)

# Guest Agent on Ubuntu

### Status

*   Building on Ubuntu
    -   GDM plugin
        -   TODO (needs to be verified, maybe even fixed)
    -   KDM plugin
        -   TODO (needs to be verified, maybe even fixed)
    -   PAM plugin
        -   TODO (needs to be verified, maybe even fixed)
*   Testing on Ubuntu
    -   Information
        -   Machine name
            -   OK
        -   Operating system version
            -   OK
        -   IP(v4) addresses
            -   OK
        -   Package query support APT support
            -   ChangeSet: <http://gerrit.ovirt.org/#/c/8642/>
        -   Available RAM
            -   OK
        -   Logged in users
            -   OK
        -   Active user
            -   OK
    -   Notifications
        -   Power Up
            -   TODO (needs to be verified, maybe even fixed)
        -   Power Down
            -   TODO (needs to be verified, maybe even fixed)
        -   Heartbeat
            -   OK
        -   User Info
            -   OK
        -   Session Lock
            -   TODO (needs to be verified, maybe even fixed)
        -   Session Unlock
            -   TODO (needs to be verified, maybe even fixed)
        -   Session Logon
            -   TODO (needs to be verified, maybe even fixed)
        -   Session Logoff
            -   TODO (needs to be verified, maybe even fixed)
        -   Agent uninstalled
            -   A script in .spec report the uninstalled message, we need to implement the same logic for the .deb package.
    -   Actions
        -   Lock screen
            -   OK
        -   Login (Single Sign On)
            -   Ubuntu currently use lightdm as default, not gdm or kdm. We need to support lightdm.
        -   Logoff
            -   Not implemented in ovirt-guest-agent/GuestAgentLinux2.py
        -   Shutdown
            -   OK

### Additional Information

The oVirt guest agent can be compiled and run on Ubuntu, without SSO and with a few workarounds. It can perform the guest OS information collecting. To try it, clone the following git repo and run ./ubuntuInstall.sh in your Ubuntu guest. [demo git repo](https://github.com/edwardbadboy/ovirtagent-ubuntu)

<Category:Ubuntu> <Category:Ovirt_guest_agent>
