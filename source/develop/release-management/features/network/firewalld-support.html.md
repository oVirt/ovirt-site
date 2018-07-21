---
title: firewalld-support
category: feature
authors: Leon Goldberg
wiki_category: Feature
wiki_title: Features/firewalld-support
wiki_revision_count: 1
wiki_last_updated: 2017-04-18
feature_name: Firewalld Support
feature_modules: Networking
feature_status: POC
---

# Firewalld Support

### Owner

*   Name: Leon Goldberg (lgoldber)
*   Email: lgoldber@redhat.com

## Summary

firewalld is a modern and natively distributed (CentOS 7+, Fedora 18+, RHEL 7+) firewall management solution. Essentially firewalld is an iptables abstraction,
allowing the use of predefined service XML files in order to configure the underlying iptables configuration. It supports both IPv4 and IPv6 and both runtime
and permanent configuration options. Additionally, firewalld provides information and accept changes via D-BUS, allowing easy interfacing.


## Benefit to oVirt

*    iptables abstraction: firewalld makes it easier for the user to configure his underlying ip(6)tables rules.
*    IPv6 support: current infrastructure only makes use of iptables which is limited to IPv4 (ip6tables is the application handling ipv6; we currently don't deploy/support ip6tables rules), while firewalld services apply both IPv4 and IPv6 rules.
*    oVirt stops acting as a second-grade firewall management system: current infrastructure supports custom rules by having them inserted in the database, and then fetched and deployed on the host.
This is both very limiting (it's system-wide or nothing; datacenter/cluster/host-wide deployment aren't supported) and cluncky (iptable rules are written as strings in the database).
In summary, oVirt shouldn't have assumed the role of a centralized firewall management system to begin with. As an alternative we are already able to provide Ansible playbooks that will be easier to use with greater customizability, 
and are currently looking to further integrate Ansible in oVirt for this purpose.
*    Firewall deployment process is greatly simplified: current infrastructure is overly complex, and a lot of it is due to having to pass entire iptable rules as string. By using firewalld, all that needs to be done is for the name of the service to be specified as required.


## Technical introduction and specification

#### Introduction

Several realizations led us to believe we could greatly simplify the current deployment process:

*    Without custom rules, hosts are able to fully derive their required firewall configuration based on their own configuration.
*    firewalld merely requires service names, in contrast to entire iptable rules. Considering the aforementioned (no custom rules; hosts are able to derive their own firewall configuration),
the responsibility of deploying firewall configuration could be left entirely to the host.

As such, a lot of the current infrastructure could be made obsolete:

*    There's no need to store iptables rules in the DB.
*    There's no need use a dedicated deploy unit (IPTablesDeployUnit) to add the relevant iptables configuration to OHD.
*    OHD's role is also no longer required as we don't need to deploy the aforementioned rules on the host. The only thing that's left required is for OHD to inform the host whether firewall configuration
should be applied (i.e. "override firewall" option).

What's left, essentially, is to allow the host to configure its firewalld zones/services based on what is expected from the host (gluster/virt).

#### Suggested specification

Beginning with a configurable threshold for cluster compatibility levels (defaulted to 4.2), instead of using/deploying iptables' deploy unit, we set a firewalld boolean in vdsm.conf's deploy unit (similarly to iptables; only in case firewall override is set).

Using a new dedicated vdsm configurator for firewalld, the required services are added to the active zone(s) (currently being just the public one) and become operational. This only takes place if firewalld's boolean is set to true in vdsm.conf. We determine what non-baseline services should be added based on what is installed on the host (e.g. gluster packages).

This approach guarantees that neither upgrading Engine nor a host separately will cause unwarranted firewall related modifications (more specifically, custom rules/iptables' service remain intact). Explicitly installing/re-installing hosts in compatible clusters via an upgraded Engine is the only way to override custom rules/enabling firewalld's service over iptables' service (barring manual alterations to vdsm.conf...). 
We're also going to warn users during engine-setup and add alerts during host (re)installations.
