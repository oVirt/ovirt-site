---
title: Troubleshooting a Self-Hosted Engine Deployment
---

# Chapter 3: Troubleshooting a Self-Hosted Engine Deployment

## Troubleshooting the Engine Virtual Machine

**Troubleshooting the Self-Hosted Engine**

1. Check the status of the Engine virtual machine by running `hosted-engine --vm-status`.

    **Note:** Any changes made to the Engine virtual machine will take about 20 seconds before they are reflected in the status command output.

Depending on the `Engine` status in the output, see the following suggestions to find or fix the issue.

**Engine status: "health": "good", "vm": "up" "detail": "up"**

1. If the Engine virtual machine is up and running as normal, you will see the following output:

        --== Host 1 status ==--

        Status up-to-date              : True
        Hostname                       : hypervisor.example.com
        Host ID                        : 1
        Engine status                  : {"health": "good", "vm": "up", "detail": "up"}
        Score                          : 3400
        stopped                        : False
        Local maintenance              : False
        crc32                          : 99e57eba
        Host timestamp                 : 248542

2. If the output is normal but you cannot connect to the Engine, check the network connection.

**Engine status: "reason": "failed liveliness check", "health": "bad", "vm": "up", "detail": "up"**

1. If the `health` is `bad` and the `vm` is `up`, the HA services will try to restart the Engine virtual machine to get the Engine back. If it does not succeed within a few minutes, enable the global maintenance mode from the command line so that the hosts are no longer managed by the HA services.

        # hosted-engine --set-maintenance --mode=global

2. Connect to the console. When prompted, enter the operating system’s root password.

        # hosted-engine --console

3. Ensure that the Engine virtual machine’s operating system is running by logging in.

4. Check the status of the `ovirt-engine` service:

        # systemctl status -l ovirt-engine
        # journalctl -u ovirt-engine

5. Check the following logs: **/var/log/messages**, **/var/log/ovirt-engine/engine.log**, and **/var/log/ovirt-engine/server.log**.

6. After fixing the issue, reboot the Engine virtual machine manually from one of the self-hosted engine nodes:

        # hosted-engine --vm-shutdown
        # hosted-engine --vm-start

    **Note:** When the self-hosted engine nodes are in global maintenance mode, the Engine virtual machine must be rebooted manually. If you try to reboot the Engine virtual machine by sending a reboot command from the command line, the Engine virtual machine will remain powered off. This is by design.

7. On the Engine virtual machine, verify that the ovirt-engine service is up and running:

        # systemctl status ovirt-engine.service

8. After ensuring the Engine virtual machine is up and running, close the console session and disable the maintenance mode to enable the HA services again:

        # hosted-engine --set-maintenance --mode=none

**Engine status: "vm": "unknown", "health": "unknown", "detail": "unknown", "reason": "failed to getVmStats"**

This status means that `ovirt-ha-agent` failed to get the virtual machine’s details from VDSM.

1. Check the VDSM logs in **/var/log/vdsm/vdsm.log**.

2. Check the `ovirt-ha-agent` logs in **/var/log/ovirt-hosted-engine-ha/agent.log**.

**Engine status: The self-hosted engine’s configuration has not been retrieved from shared storage**

If you receive the status `The hosted engine configuration has not been retrieved from shared storage. Please ensure that ovirt-ha-agent is running and the storage server is reachable` there is an issue with the `ovirt-ha-agent` service, or with the storage, or both.

1. Check the status of `ovirt-ha-agent` on the host:

        # systemctl status -l ovirt-ha-agent
        # journalctl -u ovirt-ha-agent

2. If the `ovirt-ha-agent` is down, restart it:

        # systemctl start ovirt-ha-agent

3. Check the `ovirt-ha-agent` logs in **/var/log/ovirt-hosted-engine-ha/agent.log**.

4. Check that you can ping the shared storage.

5. Check whether the shared storage is mounted.

**Additional Troubleshooting Commands**

* `hosted-engine --reinitialize-lockspace`: This command is used when the sanlock lockspace is broken. Ensure that the global maintenance mode is enabled and that the Engine virtual machine is stopped before reinitializing the sanlock lockspaces.

* `hosted-engine --clean-metadata`: Remove the metadata for a host’s agent from the global status database. This makes all other hosts forget about this host. Ensure that the target host is down and that the global maintenance mode is enabled.

* `hosted-engine --check-liveliness`: This command checks the liveliness page of the ovirt-engine service. You can also check by connecting to https://engine-fqdn/ovirt-engine/services/health/ in a web browser.

* `hosted-engine --connect-storage`: This command instructs VDSM to prepare all storage connections needed for the host and the Engine virtual machine. This is normally run in the back-end during the self-hosted engine deployment. Ensure that the global maintenance mode is enabled if you need to run this command to troubleshoot storage issues.

## Cleaning Up a Failed Self-Hosted Engine Deployment

If a self-hosted engine deployment was interrupted, subsequent deployments will fail with an error message. The error will differ depending on the stage in which the deployment failed. If you receive an error message, run the cleanup script to clean up the failed deployment.

**Running the Cleanup Script**

1. Run `/usr/sbin/ovirt-hosted-engine-cleanup` and select `y` to remove anything left over from the failed self-hosted engine deployment.

        # /usr/sbin/ovirt-hosted-engine-cleanup
        This will de-configure the host to run ovirt-hosted-engine-setup from scratch.
        Caution, this operation should be used with care.
        Are you sure you want to proceed? [y/n]

2. Define whether to reinstall on the same shared storage device or select a different shared storage device.

  * To deploy the installation on the same storage domain, clean up the storage domain by running the following command in the appropriate directory on the server for NFS, Gluster, PosixFS, or local storage domains:

          # rm -rf storage_location/*

  * For iSCSI or Fibre Channel Protocol (FCP) storage, see https://access.redhat.com/solutions/2121581 for information on how to clean up the storage.

  * Alternatively, select a different shared storage device.

3. Redeploy the self-hosted engine.

**Prev:** [Chapter 2: Deploying Self-Hosted Engine](chap-Deploying_Self-Hosted_Engine) <br>
**Next:** [Chapter 4: Migrating from Bare Metal to an EL-Based Self-Hosted Environment](chap-Migrating_from_Bare_Metal_to_an_EL-Based_Self-Hosted_Environment)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/self-hosted_engine_guide/troubleshooting)
