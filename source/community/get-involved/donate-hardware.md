---
title: Donate hardware
category: develop
authors: ederevea
---

# Donate hardware

The oVirt infrastructure can greatly benefit from donated capacity in form of virtual machines and physical servers. Below you can find the approximate specs we are looking for.

## Physical servers

Physical servers are used for oVirt CI and run various CPU and disk intensive tasks.
Our current standard is as follows:

* Recent Intel or AMD processor, 8 CPU cores or more
* 128 GB RAM
* 1TB HDD/SSD
* 100 mbps uplink (gigabit preferred)

## Virtual machines

Virtual machines are used to run all other important parts of the infrastructure such as name services, package distribution, monitoring, load balancing and backups.
Typical requirements are:

* running on redundant hardware with shared storage attached
* 2 vCPU
* 16 GB RAM
* 160 GB vHDD (up to 2TB for some use cases)
* gigabit uplink
* IPv6 connectivity
* unlimited monthly traffic

## Process

If you have spare hardware available at your datacenter that meets these requirements feel free to reach us via the [infra list](https://lists.ovirt.org). The system should have the last release of CentOS installed along with an SSH pubkey of one of the infra team members that will be used for bootstrap.

Note: If you have hardware up for donation but cannot provide hosting but can ship it to Arizona - please reach out to us via the mailing list as we may have space to accomodate it in our PHX datacenter.
