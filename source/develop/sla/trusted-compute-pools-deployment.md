---
title: Trusted compute pools deployment
authors: dave chen, gianluca, gwei3
---

This is a manual for how to deploy trusted compute pools feature in oVirt.

# Trusted Compute Pools deployment

## Owner

*   Name: [ Gang Wei](User:gwei3)
*   Last updated date: May 24, 2013
*   Email: <gang.wei@intel.com>

## Deploy Attestation Service

Two approaches (all-in-one packages for f18, yum install in f19) are provided to deploy Attestation Service. Install via yum command will be available after oat package is merged in fedora 19 repository(WIP).
pls note:
\* we encourage you to disable iptables | firewalld service, instead, config iptable to accept 8443 port, add follow line into "/etc/sysconfig/iptables"

      -A INPUT -p tcp -m state --state NEW -m tcp --dport 8443 -j ACCEPT

*   set selinux to permissive or disabled mode, config selinux in "/etc/selinux/config", eg

      SELINUX=permissive

*   oat package was not able to be pushed into fedora 18 since some dependencies can't be pushed in f18.

### Install basic packages (for all-in-one approach)

      # yum -y install httpd mysql mysql-server php php-mysql openssl java-1.7.0-openjdk.x86_64

### Install Attestation Server Package

*   Install all-in-one package

Download [oat-appraiser](http://gwei3.fedorapeople.org/package_review/oat/v1/oat-appraiser-1.6.0-1.fc18.x86_64.rpm) rpm package, and then

      # rpm -i oat-appraiser-1.6.0-1.fc18.x86_64.rpm

*   Yum Install oat server package from fedora19 repository

      # yum install oat-appraiser

*   make sure tomcat is running after package installation, otherwise, start tomcat service manually.

      # service tomcat6 status (check status)
      # service tomcat6 start (start service)

### Generate Client Files

Generate client files after installing oat-appraiser package, execute this command is enough.

      bash /usr/share/oat-appraiser/OAT_configure.sh

Client files will be output in this directory “/var/lib/oat-appraiser/ClientFiles/”. Part of these files are needed in agent’s side.

## Deploy Host Agent on VDS

Two approaches (all-in-one packages for f18, yum install in f19) are provided to deploy Host Agent.

### Install Fedora for Legacy Boot

The Fedora18/19 x86-64 system should be installed to run in legacy boot instead of EFI boot. Many new systems will by default boot as EFI boot, so you need to explicitly boot the installation media (DVD or USB) with legacy mode. Below is a example on HP8300:

*   at the beginning of booting, ESC, enter setup password, F9 -> Boot Menu -> legacy boot from DVD
*   install Fedora18/19 x86-64 from DVD

### Enable Intel® TXT in BIOS

Client system must have TPM 1.2 compliant device with driver installed, and TPM/TXT enabled in BIOS to perform the operation. Below is a example for HP8300 system:

*   Power on, ESC key -> Startup Menu -> Computer Setup(F10)
*   Security->Setup Password, set setup password as xxxxxx then F10 save it.
*   Security->System Security, enable vtx/vtd/Embeded Security Device/Trusted Execution Technology, F10 save it.
*   File->Save Changes and Exit.

### Install TPM Driver

      # yum install kernel-modules-extra

Reboot system and verify that /dev/tpm0 existed. Make sure the installed kernel-modules-extra version is the same with the kernel are you using, otherwise upgrade to a new kernel version.

### Install tboot

Download corresponding sinit zip package from below url, copied the .BIN in it to /boot. (SKIP this step on server platforms)

*   <http://software.intel.com/en-us/articles/intel-trusted-execution-technology/> . Notes: for hp8300, we use 3rd_gen_i5_i7_SINIT_51.zip

Install tboot:

      # yum install trousers-devel tpm-tools tboot
      # service tcsd enable
      # service tcsd restart

Reboot machine and select tboot option in GRUB menu at start of booting.

Check the PCR values in TPM via the sysfs interface provided by TPM driver, make sure PCR-17~19 are not all FFs.

      # find /sys/ -name pcrs
      /sys/devices/pnp0/00:0b/pcrs
      # cat /sys/devices/pnp0/00:0b/pcrs
      PCR-00: D8 FE 91 C4 10 E7 A3 F9 CA D8 C0 5F 42 AC 2D DF F7 07 90 2E
      PCR-01: 6E D4 2B 10 83 A4 8B CA 06 39 4D B0 8A DE CC 10 37 A6 06 36
      PCR-02: E2 30 5E E6 53 B1 7B 56 D9 50 9D 6F BF 6C F7 39 7F A6 9F E6
      PCR-03: 3A 3F 78 0F 11 A4 B4 99 69 FC AA 80 CD 6E 39 57 C3 3B 22 75
      PCR-04: 85 A3 4B 48 B7 67 4C 70 C3 CD FD 17 AA ED 47 33 27 C2 B3 B0
      PCR-05: 98 6D 5A 1B 4D 6D 33 81 A2 2C 81 77 2E 07 74 26 90 A4 AE 28
      PCR-06: 78 CD 77 59 86 6A 77 D0 31 03 C2 03 5B F7 DC 7E 61 DC 19 2E
      PCR-07: 3A 3F 78 0F 11 A4 B4 99 69 FC AA 80 CD 6E 39 57 C3 3B 22 75
      PCR-08: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      PCR-09: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      PCR-10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      PCR-11: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      PCR-12: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      PCR-13: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      PCR-14: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      PCR-15: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      PCR-16: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      PCR-17: 35 BF 8A 0E 18 53 EB 62 70 7F F2 18 CE 29 01 B9 EF 18 0A 6C
      PCR-18: CE 79 6B D8 8E 58 89 05 34 CF 61 31 57 1D 5A F6 52 29 3E 55
      PCR-19: EA E2 9F E2 5A 52 C9 36 3B 50 40 F5 8B 6D ED C6 E7 1C F6 29
      PCR-20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      PCR-21: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      PCR-22: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      PCR-23: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

### Install basic Packages (for all-in-one approach)

      # yum -y install trousers-devel java-1.7.0-openjdk

Make sure the TrouSers service is started before moving on. Service name is “tcsd”

### Install Host Agent Package

*   Install all-in-one package

Download [oat-client](http://gwei3.fedorapeople.org/package_review/oat/v1/oat-client-1.6.0-1.fc18.x86_64.rpm) rpm package, and then

      # rpm -i oat-client-1.6.0-1.fc18.x86_64.rpm

*   Yum Install oat client package from fedora19 repository

      # yum install oat-client

### File copying and Agent Registration

Copy “PrivacyCA.cer” and “TrustStore.jks” from server side to agent side. Find these files under this directory (server side):

*   /var/lib/oat-appraiser/ClientFiles

Copy them to this directory (agent side):

*   /usr/share/oat-client

Register host agent, make sure dialog package has been installed on your system.

      # cd /usr/share/oat-client/script
      # bash provisioner.sh

You will be required to input the host name of oat server
note:
pls input the host name of oat server, including the domain suffix
pls input the host name instead of the IP address of oat server (IP address is not supported in oat's current release)

Start oat client service, make sure TrouSers service is running

*   all-in-one approach

      # chmod 755 /etc/init.d/OATClient 
      # service OATClient start

*   yum install approach

      # service oat-client start

## Install oat-command tool

*   Install all-in-one package

Download [oat-commandtool](http://gwei3.fedorapeople.org/package_review/oat/v1/oat-commandtool-1.6.0-1.fc18.x86_64.rpm) rpm package, and then

      # rpm -i oat-commandtool-1.6.0-1.fc18.x86_64.rpm

*   Yum Install oat-commandtool package from fedora19 repository.

      # yum install oat-commandtool

You will find below 11 scripts in “/usr/bin” directory:

      # ls /usr/bin/oat_*
      oat_cert  oat_host  oat_mle  oat_mle_search  oat_oem  oat_os  oat_pcrwhitelist  oat_pollhosts  oat_view_mle  oat_view_oem  oat_view_os

## Provision White List Database

At least OEM, OS, MLE, and HOST information should be added to Attestation Server’s White List database.

Follow below exmaple to make a oVirt node recognized as "trusted" by the attestation service. (execute this command in "/usr/bin" directory):

*   Generate certification:

      # bash oat_cert  -h oatserver.*.com 

Notes: oatserver.\*.com should be the host name of oat server.

*   Add OEM:

      # bash oat_oem -a -h oatserver.*.com '{"Name":"OEM1","Description":"Newdescription"}'

*   Add OS:

      # bash oat_os -a -h oatserver.*.com '{"Name":"OS1","Version":"v1","Description":"Test1"}'

*   Add VMM type MLE

      # bash oat_mle -a -h oatserver.*.com '{"Name":"NewMLE2","Version":"v123","OsName":"OS1","OsVersion":"v1","Attestation_Type": "PCR","MLE_Type":"VMM","Description":"Test","MLE_Manifests": [{"Name": "18",  "Value": "CE796BD88E58890534CF6131571D5AF652293E55"}]}'

Notes: "18" means PCR 18, the value could be got via "# cat /sys/.../pcrs" on oat agent system, but the space chars should be removed first.

*   Add BIOS type MLE

      # bash oat_mle -a -h oatserver.*.com '{"Name":"NewMLE1","Version":"v123","OemName":"OEM1","Attestation_Type": "PCR","MLE_Type":"BIOS","Description":"MLETest1111","MLE_Manifests": [{"Name": "0",  "Value": "D8FE91C410E7A3F9CAD8C05F42AC2DDFF707902E"}]}'

Notes: "0" means PCR 0, the value could be got via "# cat /sys/.../pcrs" on oat agent system, but the space chars should be removed first.

*   Add HOST

      # bash oat_host -a -h oatserver.*.com '{"HostName":"agent.*.com","IPAddress":"192.168.1.1","Port":"9999","BIOS_Name":"NewMLE1","BIOS_Version":"v123","BIOS_Oem":"OEM1","VMM_Name":"NewMLE2","VMM_Version":"v123","VMM_OSName":"OS1","VMM_OSVersion":"v1","Email":"","AddOn_Connection_String":"","Description":""}'

Notes: by far, "IPAddress" and "Port" are not really used, so just leave a placeholder there. "HostName":"agent.\*.com" should be the host name of the oat agent (same as what hostname cmd returns on the oat agent system).

*   query the trust state of the node

      # bash oat_pollhosts -h oatserver.*.com '{"hosts":["agent.*.com"]}'

Once you got response like below the you can continue to configure oVirt engine for TCP:

      {"hosts":[{"host_name":"agent.*.com","trust_lvl":"trusted","vtime":"2013-05-16T14:14:44.881+08:00"}]}

## Configuration in oVirt Engine

User may want to configure vdc_options to overwrite the default values, these configurations include:

| options                        | default value                          |
|--------------------------------|----------------------------------------|
| SecureConnectionWithOATServers | true                                   |
| PollUri                        | AttestationService/resources/PollHosts |
| AttestationTruststore          | TrustStore.jks                         |
| AttestationPort                | 8443                                   |
| AttestationServer              | oat-server                             |
| AttestationTruststorePass      | password                               |
| AttestationFirstStageSize      | 10                                     |

*   Copy "TrustStore.jks" from attestation server to engine server, find the file in the directory of "/var/lib/oat-appraiser/Certificate/". For the environment setup by "yum install", please copy "TrustStore.jks" into "/usr/share" of engine server, for the environment setup by source code, please copy "TrustStore.jks" into "/etc/engine/ca/" of engine server.
*   Overwrite the default values. Currently, only attestation server must be specified and modified, for other options, it is okay with the default value, please follow these script to modify "AttestationServer" :

      insert into vdc_options (option_name, option_value) values (' AttestationServer','oat-server');
      update vdc_options set option_value = ‘oat-server. ***.com’ where option_name = 'AttestationServer'
