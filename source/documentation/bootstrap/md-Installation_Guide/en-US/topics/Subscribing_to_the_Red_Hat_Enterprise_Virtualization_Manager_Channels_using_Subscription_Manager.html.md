# Subscribing to the Required Entitlements

Once you have installed a Red Hat Enterprise Linux base operating system and made sure the system meets the requirements listed in the previous chapter, you must register the system with Red Hat Subscription Manager, and subscribe to the required entitlements to install the Red Hat Virtualization Manager packages.

1. Register your system with the Content Delivery Network, entering your Customer Portal user name and password when prompted:
        # subscription-manager register

2. Find the `Red Hat Enterprise Linux Server` and `Red Hat Virtualization` subscription pools and note down the pool IDs.

        # subscription-manager list --available

3. Use the pool IDs located in the previous step to attach the entitlements to the system:

        # subscription-manager attach --pool=pool_id

    **Note:** To find out what subscriptions are currently attached, run:

        # subscription-manager list --consumed

    To list all enabled repositories, run:

        # yum repolist

4. Disable all existing repositories:

        # subscription-manager repos --disable=*

5. Enable the required repositories:

        # subscription-manager repos --enable=rhel-7-server-rpms
        # subscription-manager repos --enable=rhel-7-server-supplementary-rpms
        # subscription-manager repos --enable=rhel-7-server-rhv-4.0-rpms
        # subscription-manager repos --enable=jb-eap-7-for-rhel-7-server-rpms

You have now subscribed your system to the required entitlements. Proceed to the next section to install the Red Hat Virtualization Manager packages.



