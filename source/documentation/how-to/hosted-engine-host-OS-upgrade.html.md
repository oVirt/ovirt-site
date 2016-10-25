---
title: Hosted Engine host operating system upgrade Howto
category: howto
---

# Hosted Engine host operating system upgrade Howto

## Summary

How to upgrade a hosted-engine setup on el6 hosts to el7 hosts.

## Background

oVirt 3.6 does not support installing new hosts as el6.

oVirt 3.5 did allow that, including for hosted-engine.

Upgrading hosts from el6 to el7 should be done when using 3.5.

## Assumptions

An existing oVirt 3.5 hosted-engine setup, consisting of:

* At least two hypervisors (hosts) serving the hosted-engine, with el6 (RHEL 6 or CentOS 6), one of which can be evacuated during the process
* A hosted-engine engine vm with whatever OS (irrelevant for current document)

## Upgrade process

### 1. Upgrade hosts to el7

1. Create a new cluster in the engine named 'el7'

2. Move one host to maintenance in the web admin interface.
Wait until all the VMs that were on it were migrated to other hosts, and it's displayed as being in local maintenance in:

   ```
   # hosted-engine --vm-status
   ```

3. Remove the host from the engine in the web admin interface

4. Reinstall the host with el7

5. Add relevant 3.5 repos

6. Install and deploy:

   ```
   # yum install -y ovirt-hosted-engine-setup
   # hosted-engine --deploy
   ```

   When prompted, supply the path to the existing hosted-engine storage domain.

   Accept that this is an additional host.

   When prompted, supply host ID. You can supply the same ID the host had prior to reinstall.

   You will not be able to supply host ID '1' even if reinstalling the actual first host. Supply a new unique ID.

   Eventually it will try to add the host to the engine and fail, for all hosts except for the last one, with something like:

   ```
   The host didi-box1 is in non-operational state.
   Please try to activate it via the engine webadmin UI.
   ```

   If you check engine.log on the engine vm, you should find a line like:

   ```
   2016-02-11 16:39:51,795 INFO  [org.ovirt.engine.core.vdsbroker.VdsUpdateRunTimeInfo] (DefaultQuartzScheduler_Worker-76) [7a19f193] Host 4c56fc2a-fb98-4e20-a5c8-ddb2a68e6c01 : hosted_engine_2 is already in NonOperational status for reason MIXING_RHEL_VERSIONS_IN_CLUSTER. SetNonOperationalVds command is skipped.
   ```

   This happens because it's not allowed to mix el6 and el7 hosts in the same cluster.

   In the web admin interface, move the host to maintenance, Edit, change Cluster to 'el7', Activate. After a few seconds it should turn green.

   Return to the prompt of `hosted-engine --deploy` and accept Retry in:

   ```
   Retry checking host status or ignore this and continue (Retry, Ignore)[Retry]?
   ```

   After some time the HA services will settle down, and all hosts should see the new host in `hosted-engine --vm-status`.

7. Migrate VMs as needed to the new host. You'll have to press 'Advanced' and change cluster to 'el7'.

8. Repeat steps 2 to 7 above for all other hosts.

9. When re-deploying the last host, it should not fail, and the host will be added to the cluster it was in before, usually 'Default'.

10. Optionally either move also the last host to cluster 'el7', or move all the other hosts back to the previous cluster, usually 'Default'.

### 2. Upgrade to 3.6

1. Move the HE cluster to Global maintenance.

2. Add relevant 3.6 repos to the engine vm.

3. Run on the engine vm:

   ```
   # yum update "ovirt-engine-setup*"
   # engine-setup
   ```

4. Move one host to maintenance in the web admin interface.

5. Add relevant 3.6 repos to this host.

6. Run on this host:

   ```
   # yum update -y
   ```

   In 3.6, hosted-engine keeps its configuration in the shared storage.

   After some time, you should see this in /var/log/ovirt-hosted-engine-ha/agent.log:

   ```
   MainThread::INFO::2016-02-17 13:30:01,561::upgrade::957::ovirt_hosted_engine_ha.lib.upgrade.StorageServer::(upgrade) Upgrading to current version
   ```

   And later:

   ```
   MainThread::INFO::2016-02-17 13:31:58,097::upgrade::987::ovirt_hosted_engine_ha.lib.upgrade.StorageServer::(upgrade) Successfully upgraded
   ```

7. Activate the host in the web admin interface.

   After some time, all hosts should see the upgraded host back in non-maintenance in `hosted-engine --vm-status` and with score 3400.

   When doing this on the first host, the engine vm will be shutdown, and then started on the new host, because it will have score higher than the one currently running it (which is normally 2400 in 3.5). On agent.log of the "loosing" host, you'll see something like:

   ```
   MainThread::ERROR::2016-02-23 15:12:17,511::states::385::ovirt_hosted_engine_ha.agent.hosted_engine.HostedEngine::(consume) Host didi-box1.home.local (id 3) score is significantly better than local score, shutting down VM on this host
   ```

8. Repeat steps 4 to 7 on the rest of the hosts.

9. When everything seems stable (in `hosted-engine --vm-status`, web admin alerts etc), edit the cluster 'Default' (or 'el7' if you left it like that in previous part), and change compatibility level to 3.6.

   You'll see in engine.log something like:

   ```
   2016-02-17 23:10:07,668 INFO  [org.ovirt.engine.core.dal.dbbroker.auditloghandling.AuditLogDirector] (ajp-/127.0.0.1:8702-3) [214ca5dc] Correlation ID: 214ca5dc, Call Stack: null, Custom Event ID: -1, Message: Host cluster Default was updated by admin@internal
   ```

10. If you do not have another storage domain, you should add one, so that you have a 'master' storage domain.

11. Shortly thereafter, the engine will import the hosted-engine storage domain. When this finishes, you'll see in engine.log something like:

    ```
    2016-02-17 23:10:30,728 INFO  [org.ovirt.engine.core.dal.dbbroker.auditloghandling.AuditLogDirector] (org.ovirt.thread.pool-6-thread-43) [36bc3d70] Correlation ID: 67512e3f, Call Stack: null, Custom Event ID: -1, Message: Hosted Engine storage domain imported successfully
    ```

    and later:

    ```
    2016-02-17 23:10:34,857 INFO  [org.ovirt.engine.core.dal.dbbroker.auditloghandling.AuditLogDirector] (org.ovirt.thread.pool-6-thread-47) [] Correlation ID: null, Call Stack: null, Custom Event ID: -1, Message: Hosted Engine VM was imported successfully
    ```

12. After about an hour, the engine will create OVF_STORE on the hosted-engine storage domain. You'll see in engine.log something like:

    ```
    2016-02-18 00:22:41,598 INFO  [org.ovirt.engine.core.vdsbroker.irsbroker.CreateImageVDSCommand] (DefaultQuartzScheduler_Worker-19) [355787ea] START, CreateImageVDSCommand( CreateImageVDSCommandParameters:{runAsync='true', storagePoolId='00000002-0002-0002-0002-000000000068', ignoreFailoverLimit='false', storageDomainId='91d59062-f823-40b4-a27c-f58142b6423a', imageGroupId='4a7effab-e9d0-48e1-8111-cb3a173f15f7', imageSizeInBytes='134217728', volumeFormat='RAW', newImageId='bf2719c2-63f2-48a2-8245-475ef48255f4', newImageDescription='{"DiskAlias":"OVF_STORE","DiskDescription":"OVF_STORE"}', imageInitialSizeInBytes='0'}), log id: 13368b09
    ```

    and later

    ```
    2016-02-18 00:23:13,006 INFO  [org.ovirt.engine.core.vdsbroker.irsbroker.SetVolumeDescriptionVDSCommand] (org.ovirt.thread.pool-6-thread-15) [1fe540ae] ++ description={"Updated":true,"Disk Description":"OVF_STORE","Storage Domains":[{"uuid":"91d59062-f823-40b4-a27c-f58142b6423a"}],"Last Updated":"Thu Feb 18 00:23:07 IST 2016","Size":20480}
    ```

    Before OVF_STORE is created, you'll see on the hosts, in /var/log/ovirt-hosted-engine-ha/agent.log, lines like:

    ```
    MainThread::ERROR::2016-02-18 00:23:06,076::config::234::ovirt_hosted_engine_ha.agent.hosted_engine.HostedEngine.config::(refresh_local_conf_file) Unable to get vm.conf from OVF_STORE, falling back to initial vm.conf
    ```

    After it's created, you'll see there lines like:

    ```
    MainThread::INFO::2016-02-18 00:23:16,588::ovf_store::110::ovirt_hosted_engine_ha.lib.ovf.ovf_store.OVFStore::(getEngineVMOVF) Extracting Engine VM OVF from the OVF_STORE
    ```
