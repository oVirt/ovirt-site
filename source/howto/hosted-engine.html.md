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

### Hosted Engine Howto

### Summary

This wiki provides the basic operational information needed to install, upgrade and maintain the oVirt hosted engine.

### **Contacts**

Feature Owners:
Sean Cohen <scohen@redhat.com>, Doron Fediuck <doron@redhat.com>
Setup Component owners:
Sandro Bonazzola <sbonazzo@redhat.com>, Yedidyah Bar David <didi@redhat.com>
HA Component owners:
Greg Padgett <gpadgett@redhat.com>, Martin Sivak <msivak@redhat.com>

### **Requirements**

*   Two hypervisors (hosts)
*   NFS-based shared storage (since 3.4.0) or [iSCSI storage](Feature/Self_Hosted_Engine_iSCSI_Support) (since 3.5.0 beta)
*   Access to the oVirt repository

### **Fresh Install**

Assuming you're using ovirt RPMs, you should start with install and deploy:

         # yum install ovirt-hosted-engine-setup
         # hosted-engine --deploy

During the deployment you'll be asked for input on host name, storage path and other relevant information. The installer will configure the system and run an empty VM. Access the VM and install an OS:

         [ INFO  ] Creating VM
                 ...
                 ...
                 Please install the OS on the VM.
                 When the installation is completed reboot or shutdown the VM: the system will wait until then
                 Has the OS installation been completed successfully?

After completing the OS installation on the VM, return to the host and continue. The installer on the host will sync with the VM and ask for the engine to be installed on the new VM:

        [ INFO  ] Creating VM
                 ...
                 ...
                 Please install the engine in the VM, hit enter when finished.

On the VM:

         # yum install ovirt-engine
         # engine-setup

When the engine-setup has completed on the VM, return to the host and complete the configuration. Your hosted engine VM is up and running!

**Notes:**

*   Remember to setup the same hostname you specified as FQDN during deploy while you're setting up the engine on the VM.
*   Although hosted-engine and engine-setup use different wording for the admin password ("'admin@internal' user password" vs "Engine admin password"), they are asking for the same thing. If you enter different passwords, the hosted-engine setup will fail.
*   If you want to install ovirt-engine-dwh and ovirt-engine-reports, or update the engine after the deployment is completed, remember that you need to set the system in global maintenance using
        # hosted-engine --set-maintenance --mode=global

    because the engine service must be stopped during setup / upgrade operations.

#### **Restarting form a partially deployed system**

*   If, for any reason, the deployment process breaks before its end, you can try to continue from where it got interrupted without the need to restart from scratch.

Closing up hosted-engine --deploy always generates an answerfile. You could simply try restart the deployment process with that answerfile:

      hosted-engine --deploy --config-append=/var/lib/ovirt-hosted-engine-setup/answers/answers-20150402165233.conf

*   it should start the VM from CD-ROM using the same storage device for it, but if you have already installed the OS you could simply poweroff it and select: (1) Continue setup - VM installation is complete
*   at that point it should boot the previously engine VM from the storage device and you are ready to conclude it
*   If this doesn't work you have to cleanup the storage device and restart from scratch

### **Migrate existing setup to a VM**

Moving an existing setup into a VM is similar to a fresh install, but instead of running a fresh engine-setup inside the VM, we restore there a backup of the existing engine. For full details see [Migrate_to_Hosted_Engine](Migrate_to_Hosted_Engine)

### **Installing additional nodes**

Here is an example of a deployment on an additional host:

         # yum install ovirt-hosted-engine-setup
         # hosted-engine --deploy

Once storage path is given, the installer will identify this is an additional host, and will change the flow accordingly:

         The specified storage location already contains a data domain. Is this an additional host setup (Yes, No)[Yes]? yes
         [ INFO  ] Installing on additional host
                 Please specify the Host ID [Must be integer, default: 2]:

As with the first node, this will take you to the process completion.

**Notes**

*   Remember to use the same storage path you used on first host.

### **Maintaining the setup**

The HA services have two maintenance types for different tasks.

#### **Global maintenance**

Main use is to allow the administrator to start/stop/modify the engine VM without any worry of interference from the HA agents.
In order to maintain the engine VM, use:

         # hosted-engine --set-maintenance --mode=global

To resume HA functionality, use:

         # hosted-engine --set-maintenance --mode=none

#### **Local maintenance**

Main use is to allow the administrator to maintain one or more hosts. Note that if you have only 2 nodes and one is in maintenance,
there is only one host available to run the engine VM. The way to maintain a host is by using:

         # hosted-engine --set-maintenance --mode=local

To resume HA functionality, use:

         # hosted-engine --set-maintenance --mode=none

### **Upgrade Hosted Engine**

Assuming you have already deployed Hosted Engine on your hosts and running the Hosted Engine VM, having the same oVirt version both on hosts and Hosted Engine VM.

1.  Set hosted engine maintenance mode to global (now ha agent stop monitoring engine-vm, you can see above how to activate it)
2.  Access to engine-vm and upgrade oVirt to latest version using the same procedure used for non hosted engine setups.
3.  Upgrade hosts with new packages (changes repository to latest version and run yum update -y) on this stage may appear vdsm-tool exception <https://bugzilla.redhat.com/show_bug.cgi?id=1088805>
4.  Restart vdsmd (# service vdsmd restart)
5.  Restart ha-agent and broker services (# service ovirt-ha-broker restart && service ovirt-ha-agent restart)
6.  Enter for example via UI to engine and change 'Default' cluster (where all your hosted hosts seats) compatibility version to current version (for example 3.4) and activate your hosts (to get features of the new version)
7.  Change hosted-engine maintenance to none, starting from 3.4 you can do it via UI(right click on engine vm, and 'Disable Global HA Maintenance Mode')

### **More info**

Additional information is available in the feature page [Features/Self_Hosted_Engine](Features/Self_Hosted_Engine)

# **FAQ**

### EngineUnexpectedlyDown

#### Failed to acquire lock

When the hosted engine VM is down for some reason the agent(s) will try to start it again. There is no synchronization between agents while starting the VM, so it might happen that more than one agent will try to start the VM at the same time. This is intended behavior because only one host can actually acquire the lock and run the VM. The host which failed the acquire the log will print an error to the vdsm.log: 'Failed to acquire lock: error -243'. The agent will move to the EngineUnexpectedlyDown state, because it failed to start the VM, but it will sync in a while once the timeout expires (you can grep the agent.log for "Timeout" to get the specific time when it should sync).

<Category:SLA>
