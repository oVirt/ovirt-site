# Subscribing to the Required Entitlements

To install packages signed by Red Hat you must register the target system to the Content Delivery Network. Then, use an entitlement from your subscription pool and enable the required repositories.

**Subscribing to the Required Entitlements Using Subscription Manager**

1. Register your system with the Content Delivery Network, entering your Customer Portal user name and password when prompted:

        # subscription-manager register

2. Locate the relevant subscription pools and note down the pool identifiers.

        # subscription-manager list --available

3. Use the pool identifiers located in the previous step to attach the required entitlements.

        # subscription-manager attach --pool=pool_id

4. Disable all existing repositories:

        # subscription-manager repos --disable=*

5. When a system is subscribed to a subscription pool with multiple repositories, only the main repository is enabled by default. Others are available, but disabled. Enable any additional repositories:

        # subscription-manager repos --enable=repository

6. Ensure that all packages currently installed are up to date:

        # yum update
