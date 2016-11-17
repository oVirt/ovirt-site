# Subscribing to the Required Entitlements

To be used as a virtualization host, make sure the Red Hat Enterprise Linux host meets the hardware requirements listed in [Hypervisor Requirements](sect-Hypervisor_Requirements). The host must also be registered and subscribed to a number of entitlements using Subscription Manager. Follow this procedure to register with the Content Delivery Network and attach the `Red Hat Enterprise Linux Server` and `Red Hat Virtualization` entitlements to the host.

**Subscribing to Required Entitlements using Subscription Manager**

1. Register your system with the Content Delivery Network, entering your Customer Portal **Username** and **Password** when prompted:

        # subscription-manager register

2. Find the `Red Hat Enterprise Linux Server` and `Red Hat Virtualization` subscription pools and note down the pool IDs.

        # subscription-manager list --available

3. Use the pool IDs located in the previous step to attach the entitlements to the system:

        # subscription-manager attach --pool=poolid

    **Note:** To find out what subscriptions are currently attached, run:

        # subscription-manager list --consumed

    To list all enabled repositories, run:

        # yum repolist

4. Disable all existing repositories:

        # subscription-manager repos --disable=*

5. Enable the required repositories:

        # subscription-manager repos --enable=rhel-7-server-rpms
        # subscription-manager repos --enable=rhel-7-server-rhv-4-mgmt-agent-rpms

6. Ensure that all packages currently installed are up to date:

        # yum update

    **Note:** Reboot the machine if any kernel related packages have been updated. 

Once you have subscribed the host to the required entitlements, proceed to the next section to attach your host to your Red Hat Virtualization environment.

**Warning:** Configuring networking through NetworkManager (including `nmcli` and `nmtui`) is currently not supported. If additional network configuration is required before adding a host to the Manager, you must manually write `ifcfg` files. See the [*Red Hat Enterprise Linux Networking Guide*](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Networking_Guide/index.html) for more information.

