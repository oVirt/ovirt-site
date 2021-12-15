---
title: Donate hardware
category: develop
authors:
  - ederevea
  - sandrobonazzola
---

# Resources donated so far

| Quantity / Model   | Year | Donor   | warranty status              | Used for                      |
|:---------------------------------------------------------------------------------------------------|
| 2x PowerEdge R720  | 2014 | Red Hat | extended warranty active     | storage servers               |
| 14x PowerEdge R620 | 2014 | Red Hat | **warranty expired in 2017** | hypervisors & OpenShift nodes |
| 10x PowerEdge R430 | 2016 | Red Hat | **warranty expired in 2019** | OST workers                   |
| 2x Power S812L     | 2015 | IBM     | *on loan from IBM*           | POWER8 hypervisors            |
| 3x s390 VM         |      | IBM     | -                            | s390 CI Workers               | 
| 1x s390 VM         |      | Fedora  | -                            | s390 CI Workers               |
{: .bordered}

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

Virtual machines are used to run all other important parts of the infrastructure such as name services, package distribution, monitoring, load balancing, and backups.
Typical requirements are:

* running on redundant hardware with shared storage attached
* 2 vCPU
* 16 GB RAM
* 160 GB vHDD (up to 2TB for some use cases)
* gigabit uplink
* IPv6 connectivity
* unlimited monthly traffic

## Process

If you have spare hardware available at your datacenter that meets these requirements, feel free to reach us via the [infra list](https://lists.ovirt.org).
The system should have CentOS Stream installed along with an SSH pubkey of one of the infra team members.

