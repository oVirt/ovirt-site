---
title: Summer of Code
authors: bproffitt, danken, fsimonce, mlipchuk, nsoffer
wiki_title: Summer of Code
wiki_revision_count: 19
wiki_last_updated: 2015-03-03
---

<!-- TODO: Content review -->

# Summer of Code

__FORCETOC__

For more information about Google Summer of Code (GSoC), please refer to the [official page](https://www.google-melange.com/gsoc/homepage/google/gsoc2015).

## Google Summer of Code (2014) Video Introduction

<iframe width="640" src="//youtube.com/embed/QVnN34YGz8s" frameborder="0" allowfullscreen="true"> </iframe>

## Information on oVirt and the Google Summer of Code

### For Students

Please read information about our [application requirements and advice for students](/community/activities/summer-of-code-students/) in addition to reviewing the ideas on this page. This list is not exclusive, and there are other ways you can define your GSoC project idea. It would be a good idea contribute some code for the project you are applying to work on before or during the application process.

The best way to reach out to the oVirt community about the GSoC is through these methods:

*   **Mailing List:** users@ovirt.org
*   **IRC:** #ovirt on OFTC
*   **[ oVirt GSoC Admins](#oVirt_GSoC_Admins)**

### For Mentors

The ideas can be any project that is oVirt-related and can benefit the oVirt community. When adding a project idea, please try to follow those guidelines:

*   Discuss your idea with oVirt community members in #ovirt to get their input and plan collaboration.
*   Consider ideas that consist of manageable and relevant tasks that the student can land in oVirt throughout the internship period.
*   If you're interested in mentoring the idea, put your name. If not, then just leave it blank.
*   Do not list multiple ideas with only one list item. Use multiple items instead.
*   Briefly explain why this would be great for oVirt.
*   Do not write lots of text to explain your idea. If this is going to be long, maybe it's worth creating a page for it?
*   Make sure students who do not know much about oVirt can understand the proposed idea.

When students approach you about the idea you listed:

*   Be clear with them about whether it is suitable for new contributors or for their experience level.
*   Be prepared to give them a simple bug to fix or task to complete for your module and help them along with the setup and questions about the code. Encourage them to continue on fixing more bugs or writing code for the idea they are planning to apply for.
*   If you already have a strong student applying to work on the idea, redirect other students to find other ideas to propose instead or in addition to your idea.
*   If you already have as many strong students applying to work on the ideas you plan to mentor as you can handle, redirect other students to find other ideas and mentors.
*   If you are redirecting students from your idea, please add [No longer taking applicants] to its title in the list below.
*   Don't hesitate to reach out to the oVirt GSoC admins if you need help redirecting students.

## oVirt Ideas for Google Summer of Code 2015

### **Idea:** New 2015 Idea Here

**Description:**

**Expected results:**

**Knowledge Prerequisite:**

**Mentor:**

### **Idea:** Probe Network Configuration

**Description:** An oVirt cluster contains multiple hosts that may be very different from one another when it comes to their network connectivity. Host A may have network Red and Blue connected to its `eth0` and `eth1` cards respectively, while in Host B both networks are reachable via `eth7`. When adding a fresh host C to this cluster, telling which network should be defined on which host may be quite a headache.
I'd like to see a semi-automatic configuration flow, where upon request, and existing host is asked to broadcast its network definition on top of its configured LANs. A broadcast message with the payload "Red" would be sent on top of `eth0` to neighboring hosts. If host C is connected to this network, and can sniff "Red" on its `em1` interface, it should report to Engine that network "Red" should better be configured on top of `em1`.

**Expected results:** After adding a new host to the system, Engine should be able to tell which networks does the new host see and on which interface.

**Knowledge Prerequisite:** Python

**Mentor:** [Dan Kenigsberg](mailto:danken@redhat.com)

### **Idea:** Support DNS configuration with static IP

**Description:** oVirt allows to configure the IPv4 address of network interfaces of the hosts it controls. Addresses can be acquired via DHCP are specified explicitly (static addresses). A DHCP server can (and normally does) supply address(es) of DNS (domain name server). We would like to specify primary and secondary DNS addresses for the management network, when it is set to use a static address.

**Expected results:** Vdsm API is augmented to accept a list of DNS addresses for one network. These addresses would be added to the host /etc/resolv.conf (most probably needs integration with systemd-resolved.service and/or NetworkManager). Engine API and GUI would be augmented too, to support adding these addresses, and use the new Vdsm API to set them on hosts.

**Knowledge Prerequisite:** Python (for Vdsm side), Java (for the Engine side)

**Mentor:** [Dan Kenigsberg](mailto:danken@redhat.com)

### **Idea:** RPC input type validation

**Description:** Vdsm API layer has no input validation, passing invalid input from the various RPC transports down to the application. This can hide fatal errors in client code and make debugging harder. An example failure are passing the string "true" instead of True or passing a string instead of list of strings. While vdsm fail to do any input validation, it has a schema specifying the types of all input arguments. I would like to have an automatic type validation based on vdsm schema, avoiding repetitive and error prone coding and duplication of the schema in the code.

**Expected results:** Type validation system that wrap the API layer, supporting all types defined in the schema and future types. When invalid type is detected, fail loudly and verbosely, making it easy to fix the bad client code.

**Knowledge Prerequisite:** Python

**Mentor: [Nir Soffer](mailto:nsoffer@redhat.com)**

## oVirt Ideas for Google Summer of Code 2014

### **Idea:** oVirt virtual disks advanced integration with libvirt

**Description:** oVirt is the KVM virtualization management application for large data centers. Today oVirt supports many advanced features and is looking to enhance these by fine grained control of virtual disk capabilities such as 'discard', 'eio' behavior, 'cache' type and more. These capabilities would be exposed through Rest API and web interfaces.

**Expected results:** It should be possible for the user to configure the mentioned advanced disk capabilities per storage, virtual machine and disk.

**Knowledge Prerequisite:** Python, libvirt/QEMU (bonus), Java/JBoss (bonus)

**Mentor:** [Federico Simoncelli](mailto:fsimonce@redhat.com)

### **Idea:** oVirt virt-sparsify integration

**Description:** When using virtualization, the ability to manage disk space is critical. One of the key components for achieving this is thin provisioning. However, once storage space has been allocated it is difficult to reclaim it after the virtual machine has no more need for it (e.g. user has deleted files). This project is about integrating oVirt with a utility called virt-sparsify that is able to reclaim such space and free up valuable resources.

**Expected results:** When the disk image is not in use it should be possible for the user to try and reclaim some unused space.

**Knowledge Prerequisite:** Python, libvirt/QEMU (bonus), Java/JBoss (bonus)

**Mentor:** [Federico Simoncelli](mailto:fsimonce@redhat.com)

### **Idea:** oVirt unify rpc solutions

**Description:** ovirt-engine uses XMLRPC or JSONRPC for communicating with VDSM. The JSONRPC server is using JSON schema for bridging between rpc calls and existing API classes. However, the bridge is not used to bridge the XMLRPC calls to the API, resulting in duplicate code and documentaion, and never ending synchronization between the different rpc solutions. This project is about unifing the rpc solutions so all of them will use the bridge and the schema, and duplication and manual synching is avoided.

**Expected results:** All rpc calls should use the bridge, and documentation and input and output types appear once and only once.

**Knowledge Prerequisite:** Python

**Mentor:** [Nir Soffer](mailto:nsoffer@redhat.com)

### **Idea:** Gerrit add potential reviewers

**Description:** In the open source world, when a contributor want to contribute a code to a project, he/she must gets the acknowledgement of the project maintainers for your code.
Most of the time, the review process is being done by gerrit, a web based code review and project management for Git based projects.
When the contributor submit the patch in Gerrit, he/she should add reviewers so the review process will take place, but sometimes the contributor can't be sure which reviewers will be best to add for the patch.
The contributor will sometime use the blame function to check which contributor changed most of the module recently, or any other method he thinks will be best.
The proposed project is to add to the git-review, a command-line tool for Git, an option for adding a potential reviewers to the contributor's patch.
After the contributor will submit his patch, he can use the git-review to add a potential reviewers by a specific method he will choose (blame on changed code, blame on module...)

**Expected results:** The user will add the potential reviewers he will think will be best to review his patch.

**Knowledge Prerequisite:** Python, git-review, git, gerrit

**Mentor:** [Maor Lipchuk](mailto:mlipchuk@redhat.com)

## oVirt GSoC Admins

*   [Brian Proffitt](mailto:bkp@redhat.com)
