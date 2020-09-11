---
title: Additional steps on a Hyperconverged setup
---

# Chapter: Additional Steps on the Hyperconverged Setup

The [blog](https://blogs.ovirt.org/2018/02/up-and-running-with-ovirt-4-2-and-gluster-storage/) covers the steps involved once the Hosted Engine deployment succeeds.

To outline, next steps would be:

* ~~Configure master storage domain~~
    * ~~This initializes the Data Center and imports the Hosted Engine storage domain and Hosted Engine VM.~~
* ~~Install additional hosts (with hosted engine deploy option)~~ 

 ***Since oVirt 4.2 the above steps are part of the deployment process***
* Configure a network with "gluster" network role and assign this network to the host's interface meant for storage traffic using the `Setup Host Networks` option
* Update Fencing policy on cluster
  * Edit the cluster fencing policy to ensure the following are enabled
    - Skip fencing if quorum is not met
    - Skip fencing if bricks are online
* [Optional] Configure disaster recovery

**Prev:** [Chapter: Deploying oVirt and Gluster hyperconverged](chap-Deploying_Hyperconverged.html) <br/>
**Next:** [Chapter: Troubleshooting](chap-Troubleshooting.html)

