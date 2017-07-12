---
title: DbusBackend
category: feature
authors: rbarry
feature_name: Dbus Backend
feature_modules: node
feature_status: In Progress
---

# Dbus Backend

## oVirt Node Dbus Backend

### Summary

This features adds a Dbus configuration backend for oVirt Node.

### Owner

*   Name: Ryan Barry (rbarry)

<!-- -->

*   Email: rbarry AT redhat DOT com
*   IRC: rbarry

### Detailed Description

Th main reason for this change it to adopt a common used UI for the oVirt Node.
The use of Dbus will provide control of oVirt Node in manner that is familiar to many developers out of the oVirt community.
Lastly, we can utilize common platform code and reduce the amount of duplicated work.

The Dbus provider will run as a separate service not tied to invocation of the TUI.

### Benefit to oVirt

Moving further away from tight coupling with the TUI and onto Dbus allows easy access to the configuration API from any frontend or language that has Dbus bindings. Additionally, moving towards Dbus means less logical separation when we start using Dbus interfaces not provided by Node.

### Dependencies / Related Features

Having a usable Dbus backend makes integration with [Cockpit](/develop/release-management/features/node/cockpit/) much better.

### Testing

Classes from ovirt.node.config.defaults should be visible on the Dbus System Bus Activation of methods with dbus-send or python-dbus will work, and trigger the appropriate backend classes.

Install the ovirt-node-dbus-backend RPM (can be built by cloning the git repo followed by "./autogen.sh && make rpm") on a target system which has ovirt-node installed. Or ovirt-node-lib-config, after packages are broken out.

You can also copy the ovirt-node python sources into /usr/lib/python2.7/site-packages and install the dependencies manually:

    git clone gerrit.ovirt.org:ovirt-node
    cd ovirt-node/src/ && scp -rpv ovirt* root@test:/usr/lib/python2.7/site-packages/
    ssh root@test 'yum -y install python-urwid python-augeas wget bridge-utils iscsi-initiator-utils newt-python PyPAM python-lxml python-lockfile python-gudev cracklib-python tuned

    yum -y localinstall /path/to/ovirt-node-dbus-backend*.rpm && service node-dbus start

Check the journal to see that it's started properly. It'll loop over ovirt.node.config.defaults and export methods as /org/ovirt/node/${class}, with methods available at "org.ovirt.node.${method}". These are printed out in the journal.

If you want, you can start the service in the foreground instead of with systemd.

    python /usr/lib/python2.?/site-packages/ovirt/node/dbus/service.py -d --debug

These can be tested trivially from python. For example:

    bus = dbus.SystemBus()
    obj = bus.get_object(BUS_NAME, "/org/ovirt/node/NFSv4")
    service = dbus.Interface(obj, "org.ovirt.node")
    print service.configure_domain("some.tld")

Or from the console:

    dbus-send --system --print-reply --type=method_call --dest=org.ovirt.node /org/ovirt/node/NFSv4 org.ovirt.node.configure_domain string:"some.tld"

Append "--test" if you want to use test classes, which can be directly tested with:

    python /usr/lib/python2.?/site-packages/ovirt/node/dbus/service.py -c --test

The test package approximates both a bare class of a style which doesn't currently exist, and a wrapped class which requires Node transactions to be run.

### Documentation / External references

<https://bugzilla.redhat.com/show_bug.cgi?id=1191962>

### Comments and Discussion

Comments and discussion can be posted on mailinglist or the referenced bug.

