---
title: Additional steps on a Hyperconverged setup
---

# Chapter: Additional Steps on the Hyperconverged Setup

The [blog](/blog/2017/04/up-and-running-with-ovirt-4.1-and-gluster-storage/) covers the steps involved once the Hosted Engine deployment succeeds.

To outline, next steps would be:

* Configure master storage domain
    * This initializes the Data Center and imports the Hosted Engine storage domain and Hosted Engine VM.
* Install additional hosts (with hosted engine deploy option)
* Configure a network with "gluster" network role and assign this network to the host's interface meant for storage traffic using the `Setup Host Networks` option
* Create ISO domain - you can use a new gluster volume to set this up.
* [Optional] Configure disaster recovery

**Prev:** [Chapter: Deploying oVirt and Gluster hyperconverged](../gluster-hyperconverged/chap-Deploying_Hyperconverged) <br/>
**Next:** [Chapter: Troubleshooting](../gluster-hyperconverged/chap-Troubleshooting)

