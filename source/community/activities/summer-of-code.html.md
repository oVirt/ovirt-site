---
title: Summer of Code
authors: bproffitt, danken, fsimonce, mlipchuk, nsoffer
wiki_title: Summer of Code
wiki_revision_count: 19
wiki_last_updated: 2015-03-03
---

<!-- TODO: Content review -->

# Summer of Code

For more information about Google Summer of Code (GSoC), please refer to the [official page](https://developers.google.com/open-source/gsoc/).

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

## oVirt Ideas for Google Summer of Code 2017

### **Idea:** ovirt4cli

**Description:** A configshell-based CLI for oVirt 4.x. Uses the new Python SDK (utilizing v4 REST API).

**Expected results:** A more robust command-line interface for oVirt 4.1 and beyond.

**Knowledge Prerequisite:** Python

**Mentor:** [Yaniv Kaul](mailto:ykaul@redhat.com)

### **Idea:** Packer/oVirt Integration

**Description:** Packer is a tool for creating identical machine images for multiple platforms from a single source configuration. This project would integrate Packer features into oVirt.

**Expected results:** Creating identical machine images within oVirt

**Mentor:** [Yaniv Kaul](mailto:ykaul@redhat.com)

### **Idea:** Configuring a backup storage in oVirt

**Description:** Backup storage will eventually replace the export storage domain in oVirt.

**Expected results:** The idea behind this feature is that the user will be able to configure any storage domain as backup storage domain so other platforms can use this storage domain as backup and copy VMs and data from it.

Once the storage domain is configured as backup the engine will block any running VMs or any changes that might be in the storage domain.

Eventually after this change we will be one step closer to a suitable alternative solution for the export domain.

**Mentor:** [Maor Lipchuk](mailto:mlipchuck@redhat.com)

### **Idea:** ovirt-updater tool

**Description:** CLI tool for oVirt Hypervisors which provides easy upgrade and downgrade mechanism to any supported oVirt version.

**Expected results:** The tool allows manual hypervisor upgrade to any cluster level support; i.e. "ovirt-updater --version 3.6" will install the required yum repositories that fits cluster oVirt-3.6 and will upgrade the required system's packages using yum python sdk. The tool will provide fallback flow when upgrade fails. This helps to stabilize the upgrade process and reduces the associated risks.

**Knowledge Prerequisite:** Python

**Mentor:** [Yaniv Bronhaim](mailto:ybronhei@redhat.com)

### **Idea:** Test-Kitchen/oVirt Integration

**Description:** Test Kitchen is an integration tool for developing and testing infrastructure code and software on isolated target platforms.

**Expected results:** A driver that uses the oVirt Ruby SDK gem to provision and destroy oVirt instances for your infrastructure testing.

**Knowledge Prerequisite:** Python

**Mentor:** [Marc Young](mailto:3vilpenguin@gmail.com)

### Idea: Host reservation system for testing multiple oVirt instances

**Description:** Community of QE is in need of a tool that would be able to pool hosts as a resource. The idea of this web service reservation system is to maintain unused activated hosts within assigned engines and be able to move them
from one engine to another. This orchestration on top of data centers would enable oVirt community users to benefit from easier development and testing on multiple oVirt instances.

**Expected results:** Tool to enable host pooling between different instances of oVirt.

**Knowledge Prerequisite:** Ansible, Web development

**Mentor:** [Lukas Svaty](mailto:lsvaty@redhat.com)

### Idea: Ansible playbooks for oVirt deployment with remote resources

**Description:** Ansible playbooks which are able to setup, upgrade, cleanup, collect logs oVirt engine already exist. However, at the moment these playbooks lack support for engines with resources on remote servers (database, history  aggregation service). The purpose of this project is to align currently created roles with the above mentioned remote resource scenarios.

**Expected results:** Ansible playbooks for oVirt-engine with remote resources such as databases or a DWH service.

**Knowledge Prerequisite:** Ansible

**Mentor:** [Lukas Svaty](mailto:lsvaty@redhat.com)

## oVirt Ideas for Google Summer of Code 2015

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

**Description:** oVirt is the KVM virtualization management application for large data centers. Today, oVirt supports many advanced features. We are looking to enhance these by introducing fine grained control of virtual disk capabilities such as 'eio' behavior, 'cache' type, and more. These capabilities would be exposed through Rest API and web interfaces.

**Expected results:** It should be possible for the user to configure the mentioned advanced disk capabilities per storage, virtual machine and disk.

**Knowledge Prerequisite:** Python, libvirt/QEMU (bonus), Java/JBoss (bonus)

**Mentor:** [Federico Simoncelli](mailto:fsimonce@redhat.com)

### **Idea:** oVirt virt-sparsify integration

**Description:** When using virtualization, the ability to manage disk space is critical. One of the key components for achieving this is thin provisioning. However, once storage space has been allocated it is difficult to reclaim it after the virtual machine has no more need for it (e.g. user has deleted files). This project is about integrating oVirt with a utility called virt-sparsify that is able to reclaim such space and free up valuable resources.

**Expected results:** When the disk image is not in use it should be possible for the user to try and reclaim some unused space.

**Knowledge Prerequisite:** Python, libvirt/QEMU (bonus), Java/JBoss (bonus)

**Mentor:** [Federico Simoncelli](mailto:fsimonce@redhat.com)

### **Idea:** oVirt unify rpc solutions

**Description:** The oVirt-engine uses XMLRPC or JSONRPC for communicating with VDSM. The JSONRPC server is using JSON schema for bridging between RPC calls and existing API classes. However, the bridge is not used to bridge XMLRPC calls to the API, resulting in duplicate code and documentation, and never-ending synchronization between the different RPC solutions. This project is about unifing the RPC solutions so that they will all use the bridge and the schema, so that duplication and manual syncing is avoided.

**Expected results:** All RPC calls should use the bridge, and documentation, and input and output types appear once and only once.

**Knowledge Prerequisite:** Python

**Mentor:** [Nir Soffer](mailto:nsoffer@redhat.com)

### **Idea:** Gerrit add potential reviewers

**Description:** Anyone that wishes to contribute code to an open source project, needs to have their code approved by the project's maintainers.
Most of the time, the review process is performed via Gerrit, a web-based code review and project management tool for Git-based projects.
When submitting a patch in Gerrit, the contributor needs to add reviewers. However, sometimes the contributor may not know who to add as a reviewer for a given patch.
Solutions include using the blame function, to check which contributor recently changed most of the module, or any other appropriate method.
The proposed project is to add to a git-review: a Git command-line tool for adding potential reviewers to the contributor's patch.
Upon submitting a patch, a contributor can use git-review to add potential reviewers by any chosen method (e.g. blame on changed code, blame on module, etc.).

**Expected results:** The contributor will be able to add appropriate reviewers for a proposed patch.

**Knowledge Prerequisite:** Python, git-review, git, gerrit

**Mentor:** [Maor Lipchuk](mailto:mlipchuk@redhat.com)

### **Idea:** docker-machine driver for oVirt

**Description:** [docker-machine](https://github.com/docker/machine/blob/master/CONTRIBUTING.md) is a way to create and run multiple virtual hosts to run Docker containers.
It has multiple [drivers](https://docs.docker.com/machine/drivers/) , including [kvm driver](https://github.com/dhiltgen/docker-machine-kvm) and it'd be great to have an oVirt driver as well.
It will require to create a small Go library to interface with the oVirt REST API.

**Expected results:** Ability to run docker-machine with ovirt driver.

**Knowledge Prerequisite:** Go

**Mentor:** [Yaniv Kaul](mailto:ykaul@redhat.com)

## oVirt GSoC Admins

*   [Brian Proffitt](mailto:bkp@redhat.com)
