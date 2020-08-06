---
title: DetailedHostPMProxyPreferences
category: feature
authors: emesika, yair zaslavsky
---

# Detailed Host PM Proxy Preferences

## Host Power Management Proxy Preferences

### Summary

When Power Management is defined on the Host and the host becomes non-responding , the engine will attempt to restart the Host after a graceful period is passed
The Host non-responding treatment is doing the following actions
 Send a Stop command

        Wait for status 'off' 
          (controlled by FenceStopStatusDelayBetweenRetriesInSec,FenceStopStatusRetries configuration values)
        Send a Start command
        Wait for status 'on' 
          (controlled by FenceStartStatusDelayBetweenRetriesInSec,FenceStartStatusRetries configuration values)

The current implementation of PM proxy selection is based on selection of host from the data center with 'UP' status.
 This implementation is not robust enough, since fence action such as 'RestartVds' which is comprised of two fence actions (stop & start) might be able to complete the first action, but fails to detect a proxy for the second. In some cases the entire DC becomes non-responsive or even stopped. In that case no host on DC could act as a proxy.

This document describes an extension to the current proxy selection algorithm that enables each Host to define its proxy chain as a priority list.

Specifically, the local host may be chosen as a proxy for fencing operations
This may be achieved by installing a full VDSM packages on the local machine by using
[Local VDSM](#local-vdsm)

An alternative to installing a lightweight local VDSM is writing a [Fence Wrapper](#fence-wrapper)

And finally , we can also implement it by additional [VDSM Instance](#vdsm-instance)

### Owner

*   Feature owner: Eli Mesika (emesika)

    * GUI Component owner: Eli Mesika (emesika)

    * REST Component owner: Eli Mesika (emesika)

    * Engine Component owner: Eli Mesika (emesika)

    * QA Owner: Yaniv Kaul (ykaul)

*   Email: emesika@redhat.com

### Current status

*   Target Release: 3.2
*   Status: Design
*   Last updated date: Nov 4 2012

### Detailed Description

### CRUD

Adding a pm_proxy_preferences column to vds_static table: this column represents a comma separated proxy preferences lists per Host.
The default value for this column will be : 'CLUSTER,DC'.
So, if this value is for example the default value, a Host that is in non-responsive state and has Power Management configured will be fenced
using the first UP Host in Cluster then the first UP Host in the Data Center then the engine.

Modify views vds and vds_with_tags to include pm_proxy_preferences

Update InsertVdsStatic and UpdateVdsStatic SPs to handle pm_proxy_preferences

#### DAO

Adding handling of pm_proxy_preferences to

* VdsStaticDAODbFacadeImpl
* VdsDAODbFacadeImpl

#### Metadata

- Adding test for the new pm_proxy_preferences field in VdsStaticDAOTest
- Adding test data in fixtures.xml

### Configuration

A new configuration value will be added named FenceProxyDefaultPreferences. The default value will be : CLUSTER,DC
This configuration value should be exposed to the engine-config tool.

### Business Logic

* Add pmProxyPreferences field to VdsStatic
* Add pmProxyPreferences field to VDS
* Allow to edit the PmProxyPreferences property
* FencingExecutor::FindVdsToFence
* Modify the following commands to send the value of proxy preferences settings for the Host:
  - *AddVdsCommand*
  - *UpdateVdsCommand*

------------------------------------------------------------------------

Apply the logic of searching for the proxy according to the pmProxyPreferences value

#### Flow

Start/Stop commands are passed to the Host fencing agent via a proxy machine, in this case
The pm_proxy_preferences of the Host that is in non-responding state is examined
for each entry in the comma-separated values for this field we are trying to send the fencing command (Start/Stop) via the proxy
In the case that the proxy is the local engine , a validation phase of checking existence of local installed fence-agents package is issued
The first proxy on the pm_proxy_preferences chain that succeeded to execute the command takes
If all proxies in the pm_proxy_preferences chain fails to execute the fencing operation , an ERROR is written to the log.
Actual proxy used in a fencing operation should be logged as well.

### API

The REST API will be enhanced to include the new Proxy Preferences as follows

{% highlight xml %}
  <host>
    <power_management>
       <pm_proxies>
          <pm_proxy>
             <proprietary>cluster</proprietary>
          </pm_proxy>
         <pm_proxy>
             <proprietary>dc</proprietary>
          </pm_proxy>
       </pm_proxies>
    </power_management>
 </host>
{% endhighlight %}

To achieve that we should do the following:
in api.xsd (schema) define new elements:
 *PmProxy* which contains one field : predefined

        *PmProxies* which contains a list of PmProxy

- Add enum PmProxyType {CLUSTER,DATACENTER} in org.ovirt.engine.api.model package
- Add PmProxyType enum to capabilities (BackendCapabilitiesResource)
- Add enum validations
- Add custom mapping for these new power-management fields in HostMapper.java, for both REST-->Backend and Backend-->REST directions)
- Add metadata to rsdl_metadata_v-3.1.yaml

### User Experience

A new list will be added to the Power Management Tab when adding a new Host or modifying existing Host
The list will have by default the entries : CLUSTER ,DC and ENGINE(in 3.2)
 The user may also use the UP and DOWN buttons to change items order inside the list(item order = priority)
 See [pre-defined values](#open-issues) for details.

![](/images/wiki/ProxyPreferences.png)

### Installation/Upgrade

- Add the new pm_proxy_preferences column in the upgrade script.
- Adding configuration values as described in [Configuration](#configuration)

#### User work-flows

### Enforcement

### Dependencies / Related Features and Projects

#### Affected oVirt projects

[Host Power Management Multiple Agents](/develop/release-management/features/infra/hostpmmultipleagents.html)

### Documentation / External references

[Features/HostPMProxyPreferences](/develop/release-management/features/infra/hostpmproxypreferences.html)

### Future Directions

The user may add other existing Host by pressing the ADD button, this will open a drop-down list of all available Hosts defined in the Data Center except the currently edited/added Host
 We are skipping that for the first phase since it has complexities when a Host is removed or moved to another Cluster etc.

### oVirt 3.5

This [RFE](https://bugzilla.redhat.com/show_bug.cgi?id=1054778) is planned for oVirt 3.5
We will address for 3.5 only the option to look for proxy outside the DC where the host is located and try to use other DCs
This will be done by adding to the pm_proxy_preferences field which is defaulted now to "cluster,DC" another option named other_dc.
(The pm_proxy_preferences value is available via the UI Host New/Edit PM TAB in the field named "source", in the API it is under `<pm_proxies>`)
Example of POST request to update Host pm proxy details :

{% highlight xml %}
  <host>
    <power_management type="apc_snmp">
       <pm_proxies>
          <pm_proxy>
             <type>cluster</type>
          </pm_proxy>
          <pm_proxy>
             <type>dc</type>
          </pm_proxy>
          <pm_proxy>
             <type>other_dc</type>
          </pm_proxy>
      </pm_proxies>
    </power_management>
  </host>
{% endhighlight %}

The default will stay "cluster,DC" and the admin can change this value per host using the API

### Open Issues

#### pre-defined values

Are pre-defined values applied implicitly?
Meaning, if a user modified the PM Proxy Preferences to be for example only : IP1,IP2
Does this means that this is the actual chain and if both IP1 & IP2 fails to serve as proxies the Power Management operation fails?
or, we should say that this actually implies IP1,IP2,engine,cluster,dc implicitly?
In case of that, what should we apply if user set PM Proxy Preferences to be engine,IP1,IP2 ?
Suggestion:
engine,cluster,dc should be applied implicitly and missing definitions from the original default (engine,cluster.dc) will be applied using the same priority
Examples:
engine,IP1,IP2 => engine,IP1,IP2,cluster,dc IP1,dc,IP2 => IP1,dc,IP2,engine,cluster

#### Local VDSM

In the case that engine is selected as a proxy, we may want a separate service (temporary name : local vdsm) that will run on the local host and expose only the fencing functionality from VDSM
 This option has major affect on the effort/cost and time-line of this feature since we need to write a new service for that, package it , install it etc.

#### Fence Wrapper

A script or standalone program that will call the fence-agents package scripts directly
An option is to use the separation of fenceAgent.py from API.py as suggested [here](http://gerrit.ovirt.org/#/c/7190/7/vdsm/API.py)
(Invocation in this case from [JNA](#jna) )
In this case we do not need a [Local VDSM](#local-vdsm)

#### VDSM Instance

A separate instance of vdsm, listening on a separate port.

### JNA

Java Native Access provides Java programs easy access to native shared libraries without using the Java Native Interface.

Example:
The following program loads the local C standard library implementation and uses it to call the printf function.

{% highlight java %}
      import com.sun.jna.Library;
      import com.sun.jna.Native;
      import com.sun.jna.Platform;
      /** Simple example of native library declaration and usage. */
      public class HelloWorld {
         public interface CLibrary extends Library {
             CLibrary INSTANCE = (CLibrary) Native.loadLibrary(
                 (Platform.isWindows() ? "msvcrt" : "c"), CLibrary.class);
             void printf(String format, Object... args);
         }
         public static void main(String[] args) {
             CLibrary.INSTANCE.printf("Hello, World\n");
             for (int i = 0; i < args.length; i++) {
                 CLibrary.INSTANCE.printf("Argument %d: %s\n", i, args[i]);
             }
         }
      }
{% endhighlight %}
