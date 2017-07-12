---
title: Screencasts
authors: derez, dneary, jbrooks, msalem
---

<!-- TODO: Content review -->

# Screencasts

We would like to make between 5 and 10 screencasts/video demos to show oVirt features (both new and old) before the [oVirt 3.1 release](/develop/release-management/releases/3.1/release-management/).

Each screencast consists of three phases: Scripting the demoing of the feature, recording the video which shows the feature, and finally adding a voiceover soundtrack to explain what is happening on the screen. Ideally, we can separate each of these stages to spread the load of production.

## Features to show

Priority 1 features:

*   [ Adding a new VM](#Adding_a_new_VM) to an existing oVirt cluster
*   [ Migrating a VM](#Migrating_a_VM) live to a different node
*   [ Cloning](#Cloning) a virtual machine from a template or a snapshot
*   [ Adding storage to a storage domain](#Storage)
*   [ Uploading ISOs or migrating an image using virt-v2v or virt-p2v](#Managing_images)

Priority 2 features (if we have time):

*   [ Gluster integration](#Gluster_integration) - adding and using a GlusterFS storage cluster as a storage domain for oVirt
*   [ Log collector](#Log_collector)
*   [ Backing up and restoring a VM](#Back-up_and_restore)

Each of these features needs a script (the prerequisites, the steps to follow to showcase the feature, and a general guideline to someone adding a voice-over), and someone to record the video - see [recording video](/community/get-involved/recording-video/) for how to do this, and finally, someone to add the soundtrack - see [adding a soundtrack](/community/get-involved/recording-video/#adding-a-soundtrack) for instructions.

## Adding a new VM

### Prerequisites

*   oVirt engine
*   At least two oVirt nodes
*   At least one guest image available to run on the node

### Demo steps

1.  Show the engine dashboard, with the services currently running
2.  Switch to the images view, and indicate the new VM we want to add (perhaps a web service like Wordpress would be good)
3.  Start the new service, and return to the manager view
4.  Connect to the running VM service (for example, for a Wordpress instance, connect to the IP address with a web client)
5.  Connect to the new instance via Spice to show that we can connect to it and make changes
6.  Conclude

Questions: How would one show the high-availability features which come "for free"?

## Migrating a VM

### Prerequisites

*   oVirt engine
*   At least two oVirt nodes
*   At least one running VM

### Demo steps

1.  In Engine, indicate which node the running service is on
2.  Connect to the service (eg. Wordpress blog in a web browser)
3.  Initiate a transfer of the service to another node, showing that the service remains available during the process
4.  Describe the process happening behind the scenes as VDSM does its thing
5.  Return to Engine dashboard to show that the VM is now running on a different node

## Cloning

#### Cloning a Virtual Machine from a Snapshot

### Prerequisites

*   oVirt engine
*   At least one VM

### Demo steps

1.  Login to the WebAdmin.
2.  Connect to a predefined VM using console (SPICE/VNC).
3.  Change some configurations (e.g. set oVirt.org as browser's homepage).
4.  Install some applications (e.g. Firefox).
5.  Navigate to 'Snapshots' sub-tab and create a new Snapshot.
6.  Navigate to 'Snapshots' sub-tab -> select the snapshot -> click 'Clone'.
7.  Define the cloned VM properties (name, description, etc.)
8.  Run the cloned VM and connect via console.
9.  Conclude by demonstrating the cloned VM.

### Video

[http://www.youtube.com/watch?v=EVPJXF7MLI0[http://www.youtube.com/watch?v=EVPJXF7MLI0]](http://www.youtube.com/watch?v=EVPJXF7MLI0[http://www.youtube.com/watch?v=EVPJXF7MLI0])

## Storage

### Prerequisites

### Demo steps

## Network

#### Setup Networks

### Prerequisites

*   oVirt engine
*   A host (3.1 or more) with at least three nics

### Demo steps

1.  Login to the WebAdmin.
2.  Add a Network vlan123 (vlan, vm) to the Host's Cluster
3.  Show the mtu
4.  Add a Network non_vm (not vlan, not vm) to to the Host's Cluster,
5.  Assign networks to cluster
6.  Open SetupNetworks dialog- show the nic's and network's tooltips
7.  Add the Networks to one of the free nics
8.  Create a bond between the nic we added the networks to and the free nic
9.  Edit the bond- change bonding-mode to mode2
10. Edit vlan123- change boot-protocol to static and configure ip and subnet mask
    1.  ip: 192.168.10.22
    2.  subnet mask: 255.255.255.0

11. Edit non_vm- change boot-protocol to dynamic
12. Check save network configuration and click on ok
13. Show the network interfaces table to see the changes
14. Re-open the setup networks to show changes, and open the 'edit boot protocol' for each of the attached networks.

#### Hotplug Vm Nic

### Prerequisites

*   oVirt engine
*   At least one VM

### Demo steps

1.  Login to the WebAdmin.
2.  Run the VM
3.  Add a nic to the vm, check it a activated
4.  Show the vnics table to show the new activated nic

## Managing images

### Prerequisites

### Demo steps

## Gluster integration

### Prerequisites

### Demo steps

## Log collector

### Prerequisites

### Demo steps

## Back-up and restore

### Prerequisites

### Demo steps
