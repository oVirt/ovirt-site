---
title: Hosted Engine Howto
layout: toc
category: howto
authors: aburden, alukiano, bobdrad, didi, doron, jmoskovc, msivak, rstory, sandrobonazzola,
  stirabos
---

# Hosted Engine Howto

## Summary

This wiki provides the basic operational information needed to install, upgrade and maintain the oVirt hosted engine.

## **Contacts**

Feature Owners:
Sean Cohen <scohen@redhat.com>, Doron Fediuck <doron@redhat.com>
Setup Component owners:
Sandro Bonazzola <sbonazzo@redhat.com>, Yedidyah Bar David <didi@redhat.com>
HA Component owners:
Greg Padgett <gpadgett@redhat.com>, Martin Sivak <msivak@redhat.com>

## **Requirements**

*   Two hypervisors (hosts)
*   NFS-based shared storage (since 3.4.0) or [iSCSI storage](/develop/release-management/features/sla/self-hosted-engine-iscsi-support/) (since 3.5.0 beta)
*   Access to the oVirt repository

## **Fresh Install (via CLI)**

Assuming you're using ovirt RPMs, you should start with install and deploy:

         # yum install ovirt-hosted-engine-setup
         # yum install ovirt-engine-appliance
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

## **Fresh Install (via Web UI)**

Self-Hosted Engine can be deployed also via a web UI inroduced by cockpit.
To deploy the self-hosted engine using the Cockpit user interface, follow these steps:

1. Install the cockpit-ovirt-dashboard package:

        # yum install cockpit-ovirt-dashboard
       
2. Start and enable cockpit:

        # systemctl enable cockpit.socket
        # systemctl start cockpit.socket
        
3. Allow access to Cockpit in the firewall:

        # firewall-cmd --add-service=cockpit --permanent
        # firewall-cmd --reload
        
4. Log in to the UI at https://HostIPorFQDN:9090
   
   By default, you should get a warning/popup from your browser about a self-signed certificate, unknown issuer, or something like that. Accept it, or see for [more details](http://cockpit-project.org/guide/149/https.html)
5. Navigate to *Virtualization* > *Hosted Engine*
6. Select *Hosted Engine Only Deployment*
7. Select a deployment method from the scrolldown menu:
   1. OTOPI-Based deployment - stable
   2. Ansible-Based deployment - preview (see [Feature page](https://www.ovirt.org/develop/release-management/features/sla/hosted-engine-new-deployment/) )
8. Press the *start* button

**Notes:**

*   Remember to setup the same hostname you specified as FQDN during deploy while you're setting up the engine on the VM.
*   Although hosted-engine and engine-setup use different wording for the admin password ("'admin@internal' user password" vs "Engine admin password"), they are asking for the same thing. If you enter different passwords, the hosted-engine setup will fail.
*   If you want to install ovirt-engine-dwh and ovirt-engine-reports, or update the engine after the deployment is completed, remember that you need to set the system in global maintenance using
        # hosted-engine --set-maintenance --mode=global

    because the engine service must be stopped during setup / upgrade operations.
*   It is recommended to [install the Hosted-Engine](/develop/release-management/features/integration/heapplianceflow/) using the oVirt appliance. The deployment becomes easier and quicker.

### **Restarting from a partially deployed system**

If, for any reason, the deployment process breaks before its end, you can try to continue from where it got interrupted without the need to restart from scratch.

*   Closing up, hosted-engine --deploy always generates an answerfile. You could simply try restart the deployment process with that answer file:

      hosted-engine --deploy --config-append=/var/lib/ovirt-hosted-engine-setup/answers/answers-20150402165233.conf

*   It should start the VM from CD-ROM using the same storage device for it, but if you have already installed the OS you could simply poweroff it and select: (1) Continue setup - VM installation is complete
*   At that point it should boot the previously engine VM from the storage device and you are ready to conclude it
*   If this doesn't work you have to cleanup the storage device and restart from scratch

## **Migrate existing setup to a VM**

Moving an existing setup into a VM is similar to a fresh install, but instead of running a fresh engine-setup inside the VM, we restore there a backup of the existing engine. For full details see [Migrate to Hosted Engine](/develop/developer-guide/engine/migrate-to-hosted-engine/).

## **Installing additional nodes**

This should be performed via the UI by adding a new Host with Hosted Engine installed to the desired cluster.

![Figure 1. Add New Host](/images/wiki/Add-Host-view.png "Figure 1. Add New Host")

## **Migrate hosts from EL6 to EL7**

In 3.6, EL6 is no longer supported for hosted-engine hosts. Existing 3.5 EL6 hosts should be first migrated to EL7, then upgraded to 3.6. More details in [Hosted Engine host operating system upgrade Howto](/documentation/how-to/hosted-engine-host-OS-upgrade/).

## **Migrate the engine VM from 3.6/EL6 to 4.0/EL7**

In 4.0, EL6 is no longer supported for the engine VM. Existing 3.6 EL6 engine VM should be migrated to EL7. More details can be found in [Hosted engine migration to 4.0](/develop/release-management/features/sla/hosted-engine-migration-to-4-0/).
If the engine VM is already based on el7, the user can also simply upgrade the engine there.

## **Maintaining the setup**

The HA services have two maintenance types for different tasks.

### **Global maintenance**

Main use is to allow the administrator to start/stop/modify the engine VM without any worry of interference from the HA agents.
In order to maintain the engine VM, use:

         # hosted-engine --set-maintenance --mode=global

To resume HA functionality, use:

         # hosted-engine --set-maintenance --mode=none

### **Local maintenance**

Main use is to allow the administrator to maintain one or more hosts. Note that if you have only 2 nodes and one is in maintenance,
there is only one host available to run the engine VM. The way to maintain a host is by using:

         # hosted-engine --set-maintenance --mode=local

To resume HA functionality, use:

         # hosted-engine --set-maintenance --mode=none

## **Upgrade Hosted Engine**

Assuming you have already deployed Hosted Engine on your hosts and running the Hosted Engine VM, having the same oVirt version both on hosts and Hosted Engine VM.

1.  Set hosted engine maintenance mode to global (now ha agent stop monitoring engine-vm, you can see above how to activate it)
2.  Access to engine-vm and upgrade oVirt to latest version using the same procedure used for non hosted engine setups.
3.  Select one of the hosted-engine nodes (hypervisors) and put it into maintenance mode from the engine. Note that the host must be in maintenance to allow upgrade to run.
4.  Upgrade that host with new packages (changes repository to latest version and run yum update -y) on this stage may appear vdsm-tool exception <https://bugzilla.redhat.com/show_bug.cgi?id=1088805>
5.  Restart vdsmd (# service vdsmd restart)
6.  Restart ha-agent and broker services (# systemctl restart ovirt-ha-broker && systemctl restart ovirt-ha-agent)
7.  Exit the global maintenance mode: in a few minutes the engine VM should migrate to the fresh upgraded host cause it will get an higher score
8.  When the migration has been completed re-enter into global maintenance mode
9.  Repeat step 3-6 for all the other hosted-engine hosts
10. Enter for example via UI to engine and change 'Default' cluster (where all your hosted hosts seats) compatibility version to current version (for example 3.6 and activate your hosts (to get features of the new version)
11. Change hosted-engine maintenance to none, starting from 3.4 you can do it via UI(right click on engine vm, and 'Disable Global HA Maintenance Mode')

## **Hosted Engine Backup and Restore**

Please refer to [oVirt Hosted Engine Backup and Restore](/documentation/self-hosted/chap-Backing_up_and_Restoring_an_EL-Based_Self-Hosted_Environment/) guide

## **Lockspace corrupted recovery procedure**

If you end up with corrupted sanlock lockspace due to power outage, hw failure or so, you can fix it using the following procedure:

1.  Move HE to global maintenance
2.  Stop all HE agents on all hosts (keep the local broker running)
3.  Run hosted-engine --reinitialize-lockspace from the host with running broker

You might need to use --force if something is still running, corrupted or did not report proper shutdown. But it should not be necessary for the "best" case of shutting everything down properly before the reinitialize command is issued.

## **Remove old host from the metadata whiteboard**

It is possible to remove an old host from the hosted-engine --vm-status report by using the hosted-engine --clean-metadata command. The agent has to be stopped first. You can force cleaning of a specific ID In the case when the host does not exist anymore by adding --host-id=<ID> argument.

## **Metadata too new recovery procedure**

It is possible to encounter an error like `Metadata version 2 from host 52 too new for this agent (highest compatible version: 1)` when using a block storage (iSCSI, FC, GlusterFS) for the hosted engine storage domain.

It usually means the metadata partition was not cleaned up properly by setup and contains some garbage that the hosted engine metadata parser tries to interpret as valid metadata.

The cleanup procedure requires the following steps to be done first:

1. Put the hosted engine to global maintenance using

   ```
   # hosted-engine --set-maintenance --mode=global
   ```

2. Stop the hosted engine services on ALL hosts

   ```
   # systemctl stop ovirt-ha-agent ovirt-ha-broker
   ```

The next step is to identify the proper metadata file that needs cleaning up. You can find it using:

```
# find /rhev -name hosted-engine.metadata
```

And the actual cleanup command is essentially a rewrite of all contents with zeros. Be EXTRA CAREFUL with the following command as it is destructive:

```
# dd if=/dev/zero of=/path/to/hosted_engine.metadata bs=1M
```

You can start the hosted engine services again and leave the global maintenance now.

```
# systemctl start ovirt-ha-agent ovirt-ha-broker
# hosted-engine --set-maintenance --mode=none
```

## **Handle engine VM boot problems**

To access the engine VM's console:

         # hosted-engine --add-console-password
         # remote-viewer vnc://localhost:5900

See also [Hosted Engine Console](Hosted Engine Console).

To boot from different media, e.g. a rescue CD:

1. Move to global maintenance, so that HA will not try to migrate/restart the VM.
2. Power off the engine VM - from inside it, if possible, or using one of these:

         # hosted-engine --vm-shutdown
         # hosted-engine --vm-poweroff

3. Copy /var/run/ovirt-hosted-engine-ha/vm.conf to e.g. my_custom_vm.conf.
4. Edit my_custom_vm.conf as needed.
5. Start the VM with:

         # hosted-engine --vm-start --vm-conf=my_custom_vm.conf

## **More info**

Additional information is available on the feature page [Self Hosted Engine](/develop/release-management/features/sla/self-hosted-engine).

## **FAQ**

### What is the expected downtime in case of Datacenter / Host / VM failure?

The VM should be up and running in less than 5 minutes if everything works properly. We did test three scenarios with four hosts:

1.  Kill (forced poweroff) of host A at time T
    -   T + 2 minutes - other hosts noticed and tried to start the VM (EngineStarting state)
    -   T + 3 minutes - the engine VM started responding to pings
    -   T + 5 minutes - EngineUp (good health)

2.  Complete forced poweroff of the whole cluster, first machine booting kernel at time T
    -   T + 3 minutes - EngineStarting on the first host
    -   T + 5 minutes - engine VM responding to pings

3.  Engine VM killed with kill -9
    -   T + 0 minutes (matter of seconds) - EngineStarting on other hosts
    -   T + 1 minute - engine VM responding to pings

The measured times assume the network is fine and the VM either crashed or responded to the shutdown command. There is 5 minute grace period when the VM is still running but the ovirt-engine is not responding. It can also take additional five minutes to stop the engine VM when it gets stuck and then additional five minutes to start it (if the engine is not Up after 5 minutes, we kill it and try elsewhere).

### EngineUnexpectedlyDown

#### Failed to acquire lock

When the hosted engine VM is down for some reason the agent(s) will try to start it again. There is no synchronization between agents while starting the VM, so it might happen that more than one agent will try to start the VM at the same time. This is intended behavior because only one host can actually acquire the lock and run the VM. The host which failed the acquire the log will print an error to the vdsm.log: 'Failed to acquire lock: error -243'. The agent will move to the EngineUnexpectedlyDown state, because it failed to start the VM, but it will sync in a while once the timeout expires (you can grep the agent.log for "Timeout" to get the specific time when it should sync).

### Recoving from failed install

If your hosted engine install fails, you have to manually clean up before you can reinstall. Exactly what needs to be done depends on how far the install got before failing. Here are the steps I've used, base on this [thread from the mailing list](https://lists.ovirt.org/pipermail/users/2014-May/024423.html):

*   clean up hosted engine storage. This will vary depending on your storage setup. I logged into my NFS server and purged the directory used during the hoste-engine install.

      # ls  /export/ovirt/hosted-engine
      __DIRECT_IO_TEST__  ce61789b-4291-47d6-a2a6-01263d6b4f5b
      # rm -fR /export/ovirt/hosted-engine/*

*   clean up host files

<!-- -->

    #!/bin/bash

    echo "stopping services"
    service vdsmd stop 2>/dev/null
    service supervdsmd stop 2>/dev/null
    initctl stop libvirtd 2>/dev/null

    echo "removing packages"
    yum remove \*ovirt\* \*vdsm\* \*libvirt\*

    rm -fR /etc/*ovirt* /etc/*vdsm* /etc/*libvirt* /etc/pki/vdsm

    FILES=" /etc/init/libvirtd.conf"
    FILES+=" /etc/libvirt/nwfilter/vdsm-no-mac-spoofing.xml"
    FILES+=" /etc/ovirt-hosted-engine/answers.conf"
    FILES+=" etc/vdsm/vdsm.conf"
    FILES+=" etc/pki/vdsm/*/*.pem"
    FILES+=" etc/pki/CA/cacert.pem"
    FILES+=" etc/pki/libvirt/*.pem"
    FILES+=" etc/pki/libvirt/private/*.pem"
    for f in $FILES
    do
       [ ! -e $f ] && echo "? $f already missing" && continue
       echo "- removing $f"
       rm -f $f && continue
       echo "! error removing $f"
       exit 1
    done

    DIRS="/etc/ovirt-hosted-engine /var/lib/libvirt/ /var/lib/vdsm/ /var/lib/ovirt-hosted-engine-* /var/log/ovirt-hosted-engine-setup/ /var/cache/libvirt/"
    for d in $DIRS
    do
       [ ! -d $f ] && echo "? $d already missing" && continue
       echo "- removing $d"
       rm -fR $d && continue
       echo "! error removing $d"
       exit 1
    done
