---
title: Hosted Engine Howto
category: howto
authors: aburden, alukiano, bobdrad, didi, doron, jmoskovc, rstory, sandrobonazzola,
  stirabos
wiki_category: SLA
wiki_title: Hosted Engine Howto
wiki_revision_count: 24
wiki_last_updated: 2015-05-13
---

# Hosted Engine Howto

# Summary

This wiki provides the basic operational information needed to install and maintain the oVirt hosted engine.

# **Contacts**

Feature Owners:
Sean Cohen <scohen@redhat.com>, Doron Fediuck <doron@redhat.com>
Setup Component owners:
Sandro Bonazzola <sbonazzo@redhat.com>, Yedidyah Bar David <didi@redhat.com>
HA Component owner:
Greg Padgett <gpadgett@redhat.com>, Martin Sivak <msivak@redhat.com>

# **Requirements**

*   2 hypervisors (hosts)
*   Shared storage- NFS
*   Access to oVirt repo

# **Fresh Install**

Assuming you're using ovirt RPMs, you should start with install and deploy:

         # yum install ovirt-hosted-engine-setup
         # hosted-engine --deploy

During the deployment you'll be asked for input on host name, storage path and other relevant information. The installer will configure the system and run an empty VM, so you can install an OS inside;

         [ INFO  ] Creating VM
                 ...
                 ...
                 Please install the OS on the VM.
                 When the installation is completed reboot or shutdown the VM: the system will wait until then
                 Has the OS installation been completed successfully?

After completing this part, we move on to installing the engine in the new VM;

        [ INFO  ] Creating VM
                 ...
                 ...
                 Please install the engine in the VM, hit enter when finished.

This will take you to completion of the process and having your hosted engine VM up and running!

**Notes:**

*   Remember to setup the same hostname you specified as FQDN while you're installing the OS on the VM.
*   If you want to install ovirt-engine-dwh and ovirt-engine-reports or update the engine after the deployment is completed , remember that you need to set the system in global maintenance using
        # hosted-engine --set-maintenance=global

    because the engine service must be stopped during setup / upgrade operations.

# **Migrate existing setup to a VM**

Moving an existing setup into a VM is based upon backing up the existing setup,
and restoring it into a hosted engine VM. For full details see [Migrate_to_Hosted_Engine](Migrate_to_Hosted_Engine)

# **Installing additional nodes**

Here is an example of deployment on an additional host:

         # yum install ovirt-hosted-engine-setup
         # hosted-engine --deploy

Once storage path is given, the installer will identify this is an additional host, and will change the flow accordingly:

         The specified storage location already contains a data domain. Is this an additional host setup (Yes, No)[Yes]? yes
         [ INFO  ] Installing on additional host
                 Please specify the Host ID [Must be integer, default: 2]:

As with the first node, this will take you to the process completion.

**Notes**

*   Remember to use the same storage path you used on first host.

# **Maintaining the setup**

The HA services has 2 maintenance types for different tasks.

#### **Global maintenance**

Main use is to allow the administrator to start/stop/modify the engine VM without any worry of interference from the HA agents.
In order to maintain the engine VM, use:

         # hosted-engine --set-maintenance=global

To resume HA functionality, use:

         # hosted-engine --set-maintenance=none

#### **Local maintenance**

Main use is to allow the administrator to maintain one or more hosts. Note that if you have only 2 nodes and one is in maintenance,
there is only one host available to run the engine VM. The way to maintain a host is by using:

         # hosted-engine --set-maintenance=local

To resume HA functionality, use:

         # hosted-engine --set-maintenance=none

# **More info**

Additional information is available in the feature page [Features/Self_Hosted_Engine](Features/Self_Hosted_Engine)

<Category:SLA>
