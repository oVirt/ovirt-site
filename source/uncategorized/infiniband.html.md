---
title: Infiniband
authors: suppentopf, sven
wiki_title: Infiniband
wiki_revision_count: 20
wiki_last_updated: 2014-01-23
---

# Infiniband

## Introduction

Although targeted at high performance computing Infiniband networks may be a quite cheap alternative to 10 Gigabit Ethernet. Nevertheless it is not an out of the box experience. So you expectations should never be to get close to wire speed but to be happy with every MB/s that you can reach beyond Giagbit Ethernet. This page should give a first impression for the interested reader what problems one might encounter.

## IPoIB

IP over Infiniband (IPoIB) is an encapsulation of TCP packets inside Infiniband packets. That adds a lot of overhead but comined with an NFS server it is the easiest setup that is fully implemented in OVirt.
