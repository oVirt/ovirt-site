---
title: Gdeploy Cockpit Integration
category: feature
authors: rnachimu
---

# Gdeploy integration with Cockpit-oVirt Plugin

## Summary

**Note**: this feature is now obsolete: gdeploy is not used anymore; gluster-ansible is used instead.


With the introduction of Cockpit-oVirt Plugin in oVirt Node NG, it is possible to deploy hosted-engine using cockpit.
But in a Hyper-Converged environment with Gluster, we still need to configure Glusterfs storage manually before deploying hosted engine.
Gdeploy is an ansible based tool to deploy GlusterFS Servers. It can be used to deploy Glusterfs over multiple nodes.

This feature describes a mechanism to integrate gdeploy and Cockpit-oVirt Plugin to facilitate the easy deployment of Hyper-Converged Ovirt-Gluster environment.

### Cockpit-oVirt Plugin
The [Cockpit-oVirt plugin](/develop/release-management/features/node/cockpit.html) is a [Cockpit](http://cockpit-project.org) plugin which provides VM-centric monitoring and management of a host machine while taking advantage of already built-in admin functionality in the Cockpit.
This also has a provision to deploy oVirt Hosted-Engine through Cockpit UI.

### Gdeploy
[gdeploy](https://github.com/gluster/gdeploy) is a tool to set-up and deploy GlusterFS using ansible over multiple hosts. gdeploy is written to be modular, it can be used to deploy any software depending on how the configuration file is written.
gdeploy can be used to set-up bricks for GlusterFS, create a GlusterFS volume and mount it on one or more clients from an ansible installed machine. The framework reads a configuration file and applies on the hosts listed in the configuration file.

### Owner
* Name: Ramesh Nachimuthu
* Email: rnachimu@redhat.com

### Current Status
* Status: Design
* Last updated date: 20th Sep 2016

### Benefit to oVirt

This feature will greatly improve the user experience of deploying oVirt and Gluster hyperconverged solution using oVirt Node NG. oVirt users will be benefited in following ways.

* Easy deployment using Cockpit UI
* Well integrated deployment of HCI solution
* Consistent Gluster deployment using gdeploy

### Dependencies
gdeploy package should be installed and running. gdeploy requires password less ssh from the gdeploy host to other hosts where we want to deploy gluster. This needs to be done manually before starting deployment flow.

**TBD:** explore a way to configure password less ssh using Cockpit itself.

## Detailed Description

 Existing Cockpit-Plugin can be extended to support this feature and following will be the user flow for deploying a HCI environment using Cockpit.

### UI Flow

 HCI Deployment flow can be triggered by the option 'HCI Deployment with Gluster' in HE section of Ovirt plugin. This will open the following wizard which
 help to provide all the required information about the gluster deployment.


  ![Deploy-With-Glusterfs](/images/wiki/Deploy-With-Gluster.png)


 This wizard will have following five steps.

 * Hosts:
   This will help to capture all host information like IP address in the gluster cluster.


  ![gdeploy-Hosts](/images/wiki/gdeploy-hosts.png)


* Packages:
  This is used for capturing the packages which needs to be installed. This can also take care of additional repos which needs to enabled to install those packages.
  In case of RHEL systems, this can also takes care of registering the system with CDN and enabling the required repos.

  ![gdeploy-Packages](/images/wiki/gdeploy-packages.png)

* Volumes:
  This step is used to capture the all the gluster volume details which needs to be created by gdeploy


  ![gdeploy-Volumes](/images/wiki/gdeploy-volumes.png)


* Bricks:
  This step will be used to define the bricks for the glusterfs Volumes defined in previous step.


  ![gdeploy-bricks](/images/wiki/gdeploy-bricks.png)


* Summary:
  This will be the final step in the gdeploy flow and it will show a summary of all the inputs captured in the previous steps.
  This will generate a gdeploy config file with all the inputs captured in previous step. This step will also create an answer file for Hosted-Engine deployment with default answers for HCI deployment and gluster volume information for hosted-engine storage domain.
  User can review the answer files and click 'Finish' to start executing the gluster deployment using gdeploy. Progress of gdeploy execution will be shown as it executes different steps in the deployment.


    ![gdeploy-summary](/images/wiki/gdeploy-summary.png)


    ![gdeploy-log](/images/wiki/gdeploy-log.png)


* Hosted-Engine Setup:
  After completing the gluster deployment, gdeploy wizard should start the hosted-engine deployment flow similar to how it works currently with an additional answer file generated in the previous step. Standard HE deployment work flow will start from this step. Since the answer file contains the values for hosted-engine storage domain configuration, these questions will not be asked in the hosted-engine deployment flow.


   ![he-deploy](/images/wiki/he-deploy.png)


## Implementation

We need following changes to implement this feature.

### UI Changes:

* Provide a option in 'Hosted-Engine' section to start the Hosted-Engine deployment with Gluster. This should invoke the gdeploy
wizard.

* Gdeploy wizard shown in previous section needs to implemented using react-js. At the final step, this wizard should call a script(python?) using cockpit.spawn() to generate the config files for 'gdeploy' and
'hosted-engine'. Once user reviews and confirms the generated config files then execute the 'gdeploy' command using cockpit.spawn('gdeploy -c gluster.conf'). UI should track the execution and report the results as and when different steps are being executed by gdeploy.

* After the gluster deployment, Gdeploy wizard should start the hosted-engine deployment flow similar to how it works currently with an additional answer file generated in the previous step. This answer file should have all the default answers for HCI deployement with gluster volume information for hosted-engine storage domain.

### Config generation utility

 We need to implement a config generation tool in java-script to create the answer files for 'gdeploy' and 'hosted-engine' deployment. This will be invoked from Cockpit UI plug-in with the gluster deployment details. This should generate following two answer files. [cockpit.file](http://cockpit-project.org/guide/latest/cockpit-file.html) module in Cockpit can be used to read/write/modify the config files.

 * **gluster.conf:** This will have the gdeploy configurations for HCI deployment likes gluster server details, brick details, packages needs to be installed, ports needs to be opened, volume needs to created, volume configurations, etc

 * **hosted-engine.conf:** answer file used to seed hosted-engine deployment

### HostedEngineSetup

 HostedEngineSetup in current Cockpit-oVirt plugin doesn't support passing arguments. We need to enhance this component to accept arguments so that we can pass the answer file to 'hosted-engine --deploy' command.

## External links
* [The Cockpit project](http://cockpit-project.org)
* [gdeploy](https://github.com/gluster/gdeploy)
* [HCI deployment using oVirt and Gluster](https://blogs.ovirt.org/2016/08/up-and-running-with-ovirt-4-0-and-gluster-storage/)

