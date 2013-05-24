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

<!-- -->

*   Email: <gang.wei@intel.com>

### Deploy Attestation Service

Two approaches (all-in-one package, yum install) are provided to deploy Attestation Service; Install via yum command will be available after oat package is merged in fedora 18 repository.

#### Install basic packages in RHEL (for all-in-one approach)

yum -y install httpd yum -y install mysql mysql-server yum -y install php php-mysql yum -y install openssl yum -y install java-1.7.0-openjdk.x86_64

#### Install basic packages in RHEL (for all-in-one approach)

*   Install all-in-one package

Build rpm package based on the source rpm package and install oat-appraiser package. Follow this link to get the source package. <http://sourceforge.net/projects/tboot/files/oat/oat-1.6.0-1.fc18.src.rpm>

*   Yum Install oat server package from fedora18 repository.

yum install oat-appraiser

#### Generate Client Files

Generate client files after installing oat-appraiser package, execute this command is enough. bash /usr/share/oat-appraiser/OAT_configure.sh Client files will be output in “/var/lib/oat-appraiser/ClientFiles/”. Part of these files is needed in agent’s side.

### Deploy Host Agent on VDS

Two approaches (all-in-one package, yum install) are provided to deploy Attestation Service; Install via yum command will be available after oat package is merged in fedora 18 repository.

#### Enable Intel® TXT in BIOS

Client system must have TPM 1.2 compliant device with driver installed, and TPM/TXT enabled in BIOS to perform the operation.

*   Enable Intel® TXT technology in BIOS
*   Enable TPM technology in BIOS

#### Install basic Packages in RHEL (for all-in-one approach)

yum install trousers-devel yum install java-1.7.0-openjdk

Make sure the TrouSers service is started before moving on. Service name in RHEL is “tcsd”

#### Install Host Agent Package

*   Install all-in-one package

Build rpm package based on the source rpm package and install oat-client package. Follow this link to get the source package. <http://sourceforge.net/projects/tboot/files/oat/oat-1.6.0-1.fc18.src.rpm>

*   Yum Install oat server package from fedora18 repository

yum install oat-client

#### File copying and Agent Registration

Copy “PrivacyCA.cer” and “TrustStore.jks” from server side to agent side. Find these files under this directory (server side): /var/lib/oat-appraiser/ClientFiles Copy them to this directory (agent side): /usr/share/oat-client

Go to this directory: /usr/share/oat-client/script, run provisioner.sh to register host agent. bash provisioner.sh

### Install oat-command tool

*   Install all-in-one package

Build rpm package based on the source rpm package and install oat-commandtool package. Follow this link to get the source package. <http://sourceforge.net/projects/tboot/files/oat/oat-1.6.0-1.fc18.src.rpm>

*   Yum Install oat-commandtool package from fedora18 repository.

yum install oat-commandtool

Find 11 commands totally in “/usr/bin” directory, normally, at least OEM, OS, MLE, and HOST information should be added to Attestation Server’s database. Add OS example: bash oat_os -a -h HOSTNAME_OF_OAT-APPRAISER '{Name: OS_NAME, Version: OS_VERSION, Description: DESCRIPTION}'

### Configuration in oVirt Engine

User may want to configure vdc_options to override the default values, these configurations include: SecureConnectionWithOATServers PollUri AttestationTruststore AttestationPort AttestationTruststorePass AttestationServer AttestationFirstStageSize

For example, specify attestation server with domain name, please follow these script: insert into vdc_options (option_name, option_value) values (' AttestationServer','oat-server');

update vdc_options set option_value = ‘oat-server. \*\*\*.com’ where option_name = 'AttestationServer'
