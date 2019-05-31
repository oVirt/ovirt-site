---
title: Security group support in OVN external networks
author: mdbarroso
tags: Open vSwitch, OVN, ansible, Acess Control
date: 2019-05-27 15:35:00 CET
comments: true
published: true
---

In this post I will introduce and showcase how security groups can be used to
enable certain scenarios.

[Security groups](https://developer.openstack.org/api-ref/network/v2/#security-groups-security-groups)
allow fine-grained access control to - and from - the oVirt VMs attached to
external OVN networks.

The Networking API v2 defines security groups as a white list of rules - the
user specifies in it which traffic is allowed. That means, that when the rule
list is empty, neither incoming nor outgoing traffic is allowed (from the VMs
perspective).

A demo recording of the security group feature can be found below.

[![here](http://img.youtube.com/vi/RCdV6W_tFWw/0.jpg)](http://www.youtube.com/watch?v=RCdV6W_tFWw).

READMORE

## Provided tools
[This repo](https://github.com/maiqueb/ovirt-security-groups-demo)
adds tools, and information on how to use them, to help manage the security
groups in oVirt, since currently there is no supported mechanism to provision
security groups, other than the REST API, and ManageIQ. ManageIQ also doesn't
fully support security groups, since it lacks a way to attach security groups
to logical ports.

## Demo scenarios
In the following links you can also find playbooks that can be built upon to
reach different types of scenarios.

- [Allow ICMP traffic](https://github.com/maiqueb/ovirt-security-groups-demo#icmp-configuration)
- [Allow web traffic](https://github.com/maiqueb/ovirt-security-groups-demo#web-server-configuration)
- [Configure access based on group membership](https://github.com/maiqueb/ovirt-security-groups-demo#group-membership-based-access-scenario)
