# Installing the Self-Hosted Engine Packages

Ensure the host is registered and subscribed to the required entitlements. See [Subscribing to the Required Entitlements](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/installation-guide/72-subscribing-to-the-required-entitlements) in the *Installation Guide* for more information. 

**Installing the Self-Hosted Engine**

1. Install the self-hosted engine packages:

        # yum install ovirt-hosted-engine-setup

2. Install the RHV-M Virtual Appliance package for the Manager virtual machine installation:

        # yum install rhevm-appliance

Proceed to the next section to deploy and configure self-hosted engine on a Red Hat Enterprise Linux host.
