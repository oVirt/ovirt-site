---
title: Trusted compute pools deployment
authors: dave chen, gianluca, gwei3
wiki_title: Trusted compute pools deployment
wiki_revision_count: 98
wiki_last_updated: 2014-04-01
---

This is a manual for how to deploy trusted compute pools feature in oVirt.

# Trusted Compute Pools deployment

### Owner

*   Name: [ Gang Wei](User:gwei3)
*   Last updated date: May 24, 2013

<!-- -->

*   Email: <gang.wei@intel.com>

### Deploy Attestation Service

Two approaches (all-in-one packages, yum install) are provided to deploy Attestation Service. Install via yum command will be available after oat package is merged in fedora 18 repository.

#### Install basic packages in Fedora18 (for all-in-one approach)

      yum -y install httpd
      yum -y install mysql mysql-server
      yum -y install php php-mysql
      yum -y install openssl
      yum -y install java-1.7.0-openjdk.x86_64

#### Install Attestation Server Package

*   Install all-in-one package

Build rpm package based on the source rpm package and install oat-appraiser package. Follow this link to get the source package.

<http://sourceforge.net/projects/tboot/files/oat/oat-1.6.0-1.fc18.src.rpm>

*   Yum Install oat server package from fedora18 repository (not available now).

      yum install oat-appraiser

#### Generate Client Files

Generate client files after installing oat-appraiser package, execute this command is enough.

      bash /usr/share/oat-appraiser/OAT_configure.sh

Client files will be output in this directory “/var/lib/oat-appraiser/ClientFiles/”. Part of these files are needed in agent’s side.

### Deploy Host Agent on VDS

Two approaches (all-in-one packages, yum install) are provided to deploy Attestation Service; Install via yum command will be available after oat package is merged in fedora 18 repository.

#### Enable Intel® TXT in BIOS

Client system must have TPM 1.2 compliant device with driver installed, and TPM/TXT enabled in BIOS to perform the operation.

*   Enable Intel® Trusted Execution Technology technology in BIOS
*   Enable TPM in BIOS

#### Install basic Packages in Fedora18 (for all-in-one approach)

      yum install trousers-devel
      yum install java-1.7.0-openjdk

Make sure the TrouSers service is started before moving on. Service name in RHEL is “tcsd”

#### Install Host Agent Package

*   Install all-in-one package

Build rpm package based on the source rpm package and install oat-client package. Follow this link to get the source package.

<http://sourceforge.net/projects/tboot/files/oat/oat-1.6.0-1.fc18.src.rpm>

*   Yum Install oat server package from fedora18 repository

      yum install oat-client

#### File copying and Agent Registration

Copy “PrivacyCA.cer” and “TrustStore.jks” from server side to agent side. Find these files under this directory (server side): /var/lib/oat-appraiser/ClientFiles Copy them to this directory (agent side): /usr/share/oat-client

Go to this directory: /usr/share/oat-client/script, run provisioner.sh to register host agent.

      bash provisioner.sh

### Install oat-command tool

*   Install all-in-one package

Build rpm package based on the source rpm package and install oat-commandtool package. Follow this link to get the source package.

<http://sourceforge.net/projects/tboot/files/oat/oat-1.6.0-1.fc18.src.rpm>

*   Yum Install oat-commandtool package from fedora18 repository.

      yum install oat-commandtool

Find 11 commands in “/usr/bin” directory, at least OEM, OS, MLE, and HOST information should be added to Attestation Server’s database.
Exmaple (execute this command in "/usr/bin" directory):
Generate certification:

      bash oat_cert  -h oatserver.*.com 

ADD OEM:

      bash oat_oem -a -h oatserver.*.com '{"Name":"OEM1","Description":"Newdescription"}'

ADD OS:

      bash oat_os -a -h oatserver.*.com '{"Name":"OS1","Version":"v1","Description":"Test1"}'

ADD VMM type MLE

      bash oat_mle -a -h oatserver.*.com '{"Name":"NewMLE2","Version":"v123","OsName":"OS1","OsVersion":"v1","Attestation_Type": "PCR","MLE_Type":"VMM","Description":"Test","MLE_Manifests": [{"Name": "18",  "Value": "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"}]}'

ADD BIOS type MLE

      bash oat_mle -a -h oatserver.*.com '{"Name":"NewMLE1","Version":"v123","OemName":"OEM1","Attestation_Type": "PCR","MLE_Type":"BIOS","Description":"MLETest1111","MLE_Manifests": [{"Name": "0",  "Value": "31B97D97B4679*******D943635693FFBAB4143"}]}'

ADD HOST

      bash oat_host -a -h oatserver.*.com '{"HostName":"agent.*.com","IPAddress":"192.168.1.1","Port":"9999","BIOS_Name":"NewMLE1","BIOS_Version":"v123","BIOS_Oem":"OEM1","VMM_Name":"NewMLE2","VMM_Version":"v123","VMM_OSName":"OS1","VMM_OSVersion":"v1","Email":"","AddOn_Connection_String":"","Description":""}'

POLLHOSTS

      bash oat_pollhosts -h oatserver.*.com '{"hosts":["agent.*.com"]}'

### Configuration in oVirt Engine

User may want to configure vdc_options to override the default values, these configurations include:

| options                        | default value                          |
|--------------------------------|----------------------------------------|
| SecureConnectionWithOATServers | true                                   |
| PollUri                        | AttestationService/resources/PollHosts |
| AttestationTruststore          | TrustStore.jks                         |
| AttestationPort                | 8443                                   |
| AttestationServer              | oat-server                             |
| AttestationTruststorePass      | password                               |
| AttestationFirstStageSize      | 10                                     |

currently, only attestation server must be specified and modified, for other options, it is okay with the default value, please follow these script to modify "AttestationServer" :
 insert into vdc_options (option_name, option_value) values (' AttestationServer','oat-server');

      update vdc_options set option_value = ‘oat-server. ***.com’ where option_name = 'AttestationServer'
