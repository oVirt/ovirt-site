---
title: Troubleshooting
---

# Chapter 3: Troubleshooting

## Troubleshooting the Self-Hosted Engine

**Troubleshooting the Self-Hosted Engine**

1. Check the status of the Manager virtual machine by running `hosted-engine --vm-status`.

    **Note:** Any changes made to the Manager virtual machine will take about 20 seconds before they are reflected in the status command output.

    If the Manager virtual machine is up and running as normal, you will see the following output:

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

2. If the **health** is bad or the **vm* is down, enable the global maintenance mode so that the hosts are no longer managed by the HA services.

    * In the Administration Portal, right-click the engine virtual machine, and select *Enable Global HA Maintenance**.

    * You can also set the maintenance mode from the command line:

            # hosted-engine --set-maintenance --mode=global

3. If the Manager virtual machine is down, start the Manager virtual machine. If the virtual machine is up, skip this step.

        # hosted-engine ---vm-start

4. Set the console password:

        # hosted-engine --add-console-password

5. Connect to the console. When prompted, enter the password set in the previous step.

        # hosted-engine --console

6. Determine why the Manager virtual machine is down or in a bad health state. Check `/var/log/messages` and `/var/log/ovirt-engine/engine.log`. After fixing the issue, reboot the Manager virtual machine.

7. Log in to the Manager virtual machine as root and verfiy that the `ovirt-engine` service is up and running:

        # systemctl status ovirt-engine.service

8. After ensuring the Manager virtual machine is up and running, close the console session and disable the maintenance mode to enable the HA services again:

        # hosted-engine --set-maintenance --mode=none

**Additional Troubleshooting Commands:**

**Important:** Contact the Red Hat Support Team if you feel you need to run any of these commands to troubleshoot your self-hosted engine environment.

* `hosted-engine --reinitialize-lockspace`: This command is used when the sanlock lockspace is broken. Ensure that the global maintenance mode is enabled and that the Manager virtual machine is stopped before reinitializing the sanlock lockspaces.

* `hosted-engine --clean-metadata`: Remove the metadata for a host's agent from the global status database. This makes all other hosts forget about this host. Ensure that the target host is down and that the global maintenance mode is enabled.

* `hosted-engine --check-liveliness`: This command checks the liveliness page of the ovirt-engine service. You can also check by connecting to `https://engine-fqdn/ovirt-engine/services/health/` in a web browser.

* `hosted-engine --connect-storage`: This command instructs VDSM to prepare all storage connections needed for the host and and the Manager virtual machine. This is normally run in the back-end during the self-hosted engine deployment. Ensure that the global maintenance mode is enabled if you need to run this command to troubleshoot storage issues.

## Cleaning Up a Failed Self-hosted Engine Deployment

If a self-hosted engine deployment was interrupted, subsequent deployments will fail with the following error:

    Failed to connect to broker, the number of errors has exceeded the limit.

**Prev:** [Chapter 2: Deploying Self-Hosted Engine](../chap-Deploying_Self-Hosted_Engine) <br>
**Next:** [Chapter 4: Migrating from Bare Metal to an EL-Based Self-Hosted Environment](../chap-Migrating_from_Bare_Metal_to_an_EL-Based_Self-Hosted_Environment)
