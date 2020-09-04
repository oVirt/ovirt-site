---
title: PKI Improvements
category: feature
authors: alonbl
---

# PKI Improvemnets

## Summary

Move to standard PKI PKCS#12 instead of proprietary Java Key Store, separate between engine as client key usage and engine as server key usage.

## Owner

*   Name: Alon Bar-Lev (Alonbl)

## Current status

*   merged into master.

## Detailed Description

PKCS#12 format is standard and easier to manipulate via standard tools (openssl, python).

engine as server key usage was separated to support 3rd party certificates for portal usage.

## Benefit to oVirt

PKCS#12 - easier to maintain ovirt.

key usage separation - enhance security and allow flexibility for integrators.

## Dependencies / Related Features

vdsm-reg master.

## Documentation / External references

*   [oVirt PKI 3.1 Presentation](http://resources.ovirt.org/old-site-files/wiki/OVirt_PKI_3.1.pdf)
*   [bug#854540](https://bugzilla.redhat.com/show_bug.cgi?id=854540)
*   [bug#863292](https://bugzilla.redhat.com/show_bug.cgi?id=863292)



Author: --Alon Bar-Lev (Alonbl) 02:24, 1 July 2014 (GMT)

