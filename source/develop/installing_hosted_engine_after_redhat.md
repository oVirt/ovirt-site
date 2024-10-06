## 1. Introduction

This document provides step-by-step guidance for deploying oVirt with a hosted engine in a fully virtualized environment. This setup is **not recommended for production** due to the complexities and known issues related to oVirt's recent challenges following Red Hat's discontinuation of CentOS and its impact on upstream projects like oVirt. While this guide aims to simplify the process, expect potential hurdles due to mismatches between official documentation and recent oVirt releases.

## 2. Tested and validated Versions

The following table lists the specific versions of oVirt components, ISO files, and RPM packages that have been verified to work during the installation process. These versions were tested and confirmed to deploy the hosted engine successfully.

| **Component**               | **Version**                                         | **Description**                                      | **Download Link** |
|-----------------------------|----------------------------------------------------|------------------------------------------------------|-------------------|
| **oVirt Engine Appliance RPM** | `ovirt-engine-appliance-4.5-20240817071039.1.el9.x86_64` | The oVirt Engine appliance RPM package used for deployment. | [Download RPM](https://resources.ovirt.org/repos/ovirt/github-ci/ovirt-appliance/el9/ovirt-engine-appliance-4.5-20240817071039.1.el9.x86_64.rpm) |
| **oVirt ISO**               | `ovirt-node-ng-installer-4.5.6-2024081806.el9.iso` | The oVirt ISO file used for installing the environment. | [Download ISO](https://resources.ovirt.org/repos/ovirt/github-ci/ovirt-node-ng-image/ovirt-node-ng-installer-4.5.6-2024081806.el9.iso) |
| **oVirt Engine Backend**     | `ovirt-engine-backend-4.5.7-0.master.20240719063419.git7d868bf487.el9` | Backend engine of the oVirt Engine used in the deployment. | N/A |
| **oVirt Engine Tools**       | `ovirt-engine-tools-4.5.7-0.master.20240719063419.git7d868bf487.el9` | The oVirt Engine tools package. | N/A |
| **oVirt Engine WildFly**     | `ovirt-engine-wildfly-24.0.1-1.el9.x86_64`        | WildFly application server used in oVirt deployment. | N/A |
| **oVirt Engine AAA JDBC Extension**     | `ovirt-engine-extension-aaa-jdbc-1.3.1-0.142.202307281505.el9.noarch` | DBC-based authentication extension for oVirt Engine, used to integrate external databases for user authentication. | N/A |


## 3. Setting Up the Virtualized Environment

In this step, we install oVirt Node using the latest available image at the time of writing and deploy the hosted engine on the same node. This fully virtualized environment is intended for **testing purposes** only, not for production use.

| **Resource**        | **Minimum Requirement** | **Notes**                                       |
|---------------------|--------------------------|------------------------------------------------|
| **CPU**             | 4 vCPUs                   | Adequate for managing oVirt Engine and VMs      |
| **Disk Space**      | 80 GB                     | Sufficient for oVirt and hosted engine          |
| **Network Interfaces** | 2 NICs                  | 1 NAT (for local access), 1 Bridged (for external access) |h

Ensure static IPs and DNS are correctly configured to avoid networking issues during the hosted engine setup.

### 3. Network Configuration

Having a properly configured network is crucial for a successful oVirt deployment. Both **DNS** and **NTP** must be correctly set up to ensure smooth communication between the oVirt Engine and the hypervisor nodes.

#### DNS Setup
Ensure that both forward (A) and reverse (PTR) DNS records are configured and resolvable from the hypervisors and the oVirt Engine, regardless of their network. Incorrect DNS resolution can lead to communication and authentication failures during the hosted engine setup.

#### Testbed Environment Setup
In our testbed environment, we used **libvirt's dnsmasq** and manually configured `/etc/hosts` for the host (where the ovirt node vm is running), the ovirt node itself so it provides dns to the Hosted Engine, and finally for the engine but please note that the deployment process does this setup by itself.  The critical point is to ensure that each could resolve the others by FQDN.

Example `/etc/hosts` configuration:
```bash
127.0.0.1   localhost localhost.localdomain
::1         localhost localhost.localdomain
10.0.3.15   node1.ovirt.local node1
10.0.3.18   engine.ovirt.local engine
```
This approach works in small setups, but for production environments, a dedicated DNS service is recommended.

#### NTP Configuration
Accurate time synchronization is equally important for avoiding issues in distributed systems. Ensure all nodes and the engine are using the same NTP server for time synchronization.

---

## 4. NFS Storage setup

In order to have a successful deployment is critical to ensure the proper setup of your storage, following you will find the instructions to setup an Ubuntu server as NFS Server compatible with oVirt.  Independent on what do you use for the NFS Storage or the shared storage for that matters is critical to check the proper access from the nodes as explained later in this document.

#### Setting NFS Server

**Ubuntu 22.04/24.04**

Edit /etc/default/nfs-kernel-server and remove the --manage-gids option from rpc.mountd

```console
    #RPCMOUNTDOPTS="--manage-gids"
    RPCMOUNTDOPTS=""
```
Edit /etc/export and configure your exported resource as follows:

```console
    /storage *(rw,insecure,all_squash,anonuid=36,anongid=36)
```

The insecure flag is required when the connection from your hosts come from a port >1024, which is the case in virtualized environments.
The all_squash is to force all connections to use the defined anonuid and anongid ids.

Restart the NFS server.

```console
    systemctl restart nfs-kernel-server
```

You can go to 6. and test the storage at once or wait until you have your OVirt node deployed to test it from there.

## 5. OVirt Node installation

This is the step-by-step installation process of oVirt with a self-hosted engine. It is essential to ensure network and DNS resolution are configured properly before proceeding with the steps outlined below, as well as the proper access to the shared storage as explained.

---

#### Step 1: Install the ISO

Begin by installing the oVirt Node ISO on your system. The following system configuration is recommended:

- **RAM**: Minimum of 16 GB  
- **Disk**: 80 GB  
- **Network Interface Cards (NICs)**: In the testbed environment we used two NICs, one NAT for libvirt and the other for public access, however this may vary depending your needs.  Just have in mind the need of proper DNS resolution and connectivity.

Once you have launched the VM or physical system with the oVirt Node ISO, proceed with the following:

1. Use the entire drive for the installation.  
2. Configure both network cards (ensure one is for public access and one for storage/private networking).  
3. Assign a **hostname** (e.g., `node1.ovirt.local`), and set a **password** for access.  

---

#### Step 2: Post-Installation Configuration

Once the installation is complete, SSH into the newly installed system and perform the following checks:

1. **DNS Resolution**: Ensure proper resolution for both A and PTR records by checking network connectivity and hostname resolution.  
   
   Example:  
   ```bash
   ping engine.ovirt.local
   ```

2. **Edit `/etc/hosts`**: Make sure `/etc/hosts` contains the correct IP-to-hostname mappings for the engine and the node itself.  
   Example:  
   ```bash
   127.0.0.1   localhost  
   10.0.3.15   node1.ovirt.local  
   10.0.3.18   engine.ovirt.local  
   ```

3. **Edit `/etc/resolv.conf`**: Ensure the correct DNS server is set up:  
   ```bash
   nameserver 192.168.122.1
   ```
As we are using Libvirt's Dnsmasq in this setup, the nameserver is 192.168.122.1 but that may vary in your environment, even if it's also KVM/Libvirt.

4. **Test Connectivity**: Ensure access to the shared storage (NFS/GlusterFS/etc.) and verify that network services are working.

   ```bash
    host engine.ovirt.local
    showmount -e 10.0.3.16
  ``` 

---

#### Step 3: Install Necessary Packages

Before setting up the oVirt engine, install the necessary packages by adding the appropriate repository and syncing with the correct versions:

```bash
dnf copr enable -y ovirt/ovirt-master-snapshot centos-stream-9  
dnf install -y ovirt-release-master  
dnf distro-sync --nobest  
dnf install ovirt-engine-appliance
```

This ensures you are using the correct nightly build and package versions for a smooth deployment according to the latest recommendation from the developers. [1|https://www.ovirt.org/develop/dev-process/install-nightly-snapshot.html]

The ovirt-engine-appliance tested is the one referred at the beginning of this document, it may not work with a different version, if that's the case download the RPM indicated and install it directly on the OVirt node.

---

#### Step 4: Prepare Ansible Variables & Start the Hosted Engine Setup

Create an `ansible-vars.yml` file to include critical options for the hosted engine setup:

```bash
cat /root/ansible-vars.yml  
---  
he_pause_host: true  
he_offline_deployment: true  
he_pause_before_engine_setup: true  
he_enable_keycloak: false  
he_debug_mode: true  
```

The one that you really need is the he_offline_deployment because this avoids the updating process that mess up the installation, however in order to check the advance of the installation and validate that everything is going well you may need the pause and debug options as well.  I used the he_enable_keycloak but it didn't work, so pay attention to that question and answer no because in my case failed in every attempt.

To ensure the installation process runs smoothly and avoids package updates during deployment, use the following command to start the hosted engine deployment:

```bash
tmux  
hosted-engine --deploy --4 --ansible-extra-vars="@/root/ansible-vars.yml"
```

It is recommended to use `tmux` to avoid losing your session if disconnected. This will allow the process to continue running in the background.

---

#### Step 5: Critical Questions During Installation

The hosted engine deployment will ask several important questions. Below are key questions and answers:

- **Please indicate the gateway IP address**:  
  Use the IP of the gateway on the public interface (the one providing internet access).  
  Example: `10.0.3.1`

  **NOTE: This must be an existing gateway**


- **Configure Keycloak integration on the engine**:  
  Choose **No** to avoid complications with Keycloak integration (this has been known to cause issues).  
  Example: `

```bash
Configure Keycloak integration on the engine (Yes, No) [Yes]: No
```

  **NOTE: This is a hard NO, it didn't work at all in my tests no matter the versions used.**

- **Please indicate a NIC to set ovirtmgmt bridge**:  
  Choose the NIC that will act as the management bridge for your public network.  
  Example: `enp1s0`
  
  **NOTE: This must be the external network card, not the NATed one.**

- **Engine VM FQDN**:  
  Provide the fully qualified domain name (FQDN) for the engine VM. This must resolve correctly (both A and PTR records).
  
  Example:  
  ```bash
  Engine VM FQDN: engine.ovirt.local
  ```
  **NOTE: This must be the right DNS record assigned to your engine and this MUST resolve properly.**

- **How should the engine VM network be configured? (DHCP, Static)**:  
  Use **Static** for better control.  
  Example: `Static`

  **NOTE: Unless you have proper configured your DHCP to reserve and assign the right address, use Static.**

- **Please enter the IP address to be used for the engine VM**:  
  Provide the static IP that resolves to the engine’s FQDN.  
  Example: `10.0.3.14`

  **NOTE: This must be the right IP address assigned to your engine and this MUST resolve properly.**

- **Engine VM DNS**:  
  Provide a comma-separated list of DNS servers the engine should use.  
  Example: `192.168.122.1,10.0.3.3`
  
  **NOTE: As we are using Libvirt's Dnsmasq the first DNS is that one, it may vary in your setup, I just repeat it again, it needs to properly resolve the engine's IP address.**

- **Check FQDN resolution**:  
  The installer will verify if the engine VM's FQDN resolves. Ensure it resolves to the correct IP address before proceeding.  

  Example:  
  ```bash
  [ INFO ] The Engine VM FQDN was resolved into: '10.0.3.14'
  ```

- **Storage Configuration**:  
  The next step in the deployment process is configuring shared storage. Make sure the shared storage (NFS, GlusterFS, etc.) is accessible and properly configured.


## 6. NFS Storage testing process before continue


From your hosts mount the nfs storage and test with root, vdsm and sanlock users that you have full access to the shared resource.

```console

    mount nfs_ip_address:/storage /mnt
    cd /mnt
    touch test_root
    ls -l test_root  # Must look like this:  -rw-r--r--. 1 vdsm kvm 0 Oct  5 17:22 test_root
    rm test_root
    sudo su - vdsm -s /bin/bash
    cd /mnt
    touch test_vdsm
    ls -l test_vdsm  # Must look like this:  -rw-r--r--. 1 vdsm kvm 0 Oct  5 17:22 test_vdsm
    rm test_vdsm
    sudo su - ceph -s /bin/bash
    cd /mnt
    touch test_ceph
    ls -l test_ceph  # Must look like this:  -rw-r--r--. 1 vdsm kvm 0 Oct  5 17:22 test_ceph
    rm test_ceph
    sudo su - sanlock -s /bin/bash
    cd /mnt
    touch test_sanlock
    ls -l test_sanlock  # Must look like this:  -rw-r--r--. 1 vdsm kvm 0 Oct  5 17:22 test_sanlock
    rm test_sanlock
```

This assumes there is full connectivity between your hosts and the NFS server and all the firewalls involved are properly setup.

The engine doesn't really need access to the storage, just the nodes but it won't harm you to test from there too.

---

## 7: Continue the host-deploy process:

During the storage configuration step, ensure that the shared storage is available and reachable from the host and the engine VM. The deployment will prompt you to provide details for the storage domain, such as the NFS server and path:

- **Please indicate where the storage should be mounted**:  
  Provide the mount path for the NFS or other shared storage location where the engine VM will reside.

  Example:  
  ```bash
  Storage mount path: 10.0.3.16:/engine_storage
  ```

Ensure that the NFS or other storage protocol is properly configured, permissions are set, and network connectivity allows access from both the host and the engine VM.

---

## 8: Completing the Hosted Engine Setup

Once the engine VM starts, the deployment process will continue with configuring the shared storage, moving the engine VM to shared storage, and initializing services. You will see tasks like:

```bash
TASK [ovirt.ovirt.hosted_engine_setup : Copy local VM disk to shared storage]  
[ INFO ] changed: [localhost]
```

As the process continues, the engine VM will be initialized, and services like `ovirt-ha-agent` will start:

```bash
TASK [ovirt.ovirt.hosted_engine_setup : Start ovirt-ha-agent service on the host]  
[ INFO ] changed: [localhost]
```

After the process completes successfully, you will see the following message:

```bash
[ INFO ] Hosted Engine successfully deployed
```

At this point, the self-hosted engine setup is complete, and you can begin managing your virtual infrastructure using the oVirt engine.

---

## Summary

By following these steps, you will have successfully deployed oVirt with a self-hosted engine in your environment. Pay special attention to DNS resolution, network configuration, and storage access to avoid issues during the installation. Use `tmux` to ensure the process runs uninterrupted, and leverage the `he_offline_deployment` variable to prevent unexpected updates during the setup.

```
