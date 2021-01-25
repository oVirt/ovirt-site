---
title: OS info
category: feature
authors: mlipchuk, roy, sandrobonazzola
feature_name: OS info
feature_modules: oVirt
feature_status: Released
---

# OS info

### Summary

This feature enables ovirt to configure all its OS info in one place, out of the code, and in a way admins could extend it or easily configure it.
It aims to merge all configuration items from the Config (currently vdc_options table) and the VmOsType.java enum to one file-based repository.

### Owner

*   Name: Roy Golan (rgolan)
*   Email: <rgolan@redhat.com>

### Current status

*   WIP, patches submitted gerrit.ovirt.org/#/q/topic:osinfo,n,z. >90% implemented and verified.last bits of searchengine integration
*   Last updated: ,
*   Target Release: 3.3

### History

Engine is keeping a **VmOsType.java** enum to list some of the OS capabilities such as 64 bit support. other capabilities are kept in the DB as lists, based upon
the enum member name. examples:
There's a general config value for min/max memory to use for all OSs.
sound card to attach to vm is a config value - Config.desktopAudioDeviceType=default,ich6,windowsXP,ac97 UI and REST has a static traslation beased on the enum members
UI builds a the image icon url based on the names as well. list goes on with config values per windows os product key, sysprep file path and so on
=== current implementation downsides === while our state is static for we compile and rely on the VmOsType members, its not extendible, its hard-coded, and config values must compy with the hard-coded names.

## New Design

### File based configuration

oVirt will keep its own repository of OS configuration, in a properties file format, under **$ENGINE_USR** which and that could be extended in **$ENGINE_ETC**. Engine will load all files sorted by name, to supply defaults and a way to override them.

      $ENGINE_USR/conf/osinfo-default.properties
      $ENGINE_ETC/conf/osinfo.conf.d/00-osinfo.properties  <-- a symlink to osinfo-default.properties

The format is key=value and have several features:

#### Value versions

values can be different per compatibility versions;

        os.rhel6.key.value = foo                           // a general version value
        os.rhel6.key.value.version.3.2 = bar     // 3.2 compatibility version value

#### value overriding

Supports versions of configuration through file prefix e.g - all or some entries in this file can be overridden by entries in 10-osinfo.properties

#### Inheritance

Specify the 'derivedFrom' key and the os id to inherit all its values except id.

#### I18N

This file is also loaded as a String Bundle so name and description can contain non-ASCII values. This file is the default en-us locale while loading 10-osinfo_he-il.properties will contain Hebrew locale values e.g os.linux.name.value = לינוקס

snip from **osinfo-defaults.properties**

      os.default.id.value = 0
      # name is I18N if the one creates a 01-os_${LOCALE}.properties with the co-responding name property
      os.default.name.value = default OS
      # OS family values: Linux/Windows/Other
      os.default.family.value = Other
      # CPU architecture (*not* the bus width 64/32 bit). Currently only x86 is supported
      # but ppc7 is a work in progress and possibly arm someday as well
      os.default.cpuArchitecture.value = x86
      os.default.bus.value = 32
      os.default.resources.minimum.ram.value = 256
      os.default.resources.maximum.ram.value = 64000
      os.default.resources.minimum.disksize.value = 1
      os.default.resources.minimum.numberOsCpus.value = 1
      os.default.spiceSupport.value = true

      os.default_64.derivedFrom.value = default
      os.default_64.bus.value = 64

### Engine's Os Repository

On engine startup, engine will seek the **@ENGINE_ETC** dir and will load by order all **\*.properties** file under **conf/osinfo.conf.d**.
The properties will be kept in an internal tree so its easy to walk it for values, parent values and values with compatibility version
All components besides UI can get an instance of **OsRepositoryImpl** or indirectly query it by a backend VDC Query- **OsRepositoryQuery**
FUTURE: serialize the OsRepository to the UI instead of a exposing pats of it in a query? - had significant hard time with GWT to serialize the OsRepository to the UI
due to my usage of *java.util.prefs.Preferences*.

OsRepository interface;

        /**
        * Interface for accessing all Virtual OSs information.
        */
        public interface OsRepository {
         /**
          * @return all loaded os ids
          */
         public ArrayList`<Integer>` getOsIds();
         /**
          * @return map of osId to the the os name
          */
         public HashMap`<Integer, String>` getOsNames();
         public String getOsName(int osId);
         /**
          * OS families are basically windows,linux and other.
          * @param osId
          * @return
          */
         public String getOsFamily(int osId);
         /**
          * @return a list of OSs who's {@link OsRepository#getOsFamily(int)} returns "linux"
          */
         public ArrayList`<Integer>` getLinuxOSs();
         public ArrayList`<Integer>` get64bitOss();
         /**
          * @return a list of OSs who's {@link OsRepository#getOsFamily(int)} returns "windows"
          */
         public ArrayList`<Integer>` getWindowsOss();
         /**
          * @return minimum RAM in mb
          */
         public int getMinimumRam(int osId, Version version);
         /**
          * @return maximum RAM in mb
          */
         public int getMaximumRam(int osId, Version version);
         /**
          * @return if that OS could be connected with SPICE
          */
         public boolean hasSpiceSupport(int osId, Version version);
         /**
          * this is Windows OSs specific path to the sysprep file
          * @param osId
          * @param version
          * @return
          */
         public String getSysprepPath(int osId, Version version);
         /**
          * this Windows OSs specific product key
          * @param osId
          * @param version
          * @return
          */
         public String getProductKey(int osId, Version version);
         /**
          * a convenience method the for  family type "linux"
          * @param osId
          * @return
          */
         public boolean isLinux(int osId);
         /**
          * a convenience method the for  family type "windows"
          * @param osId
          * @return
          */
         public boolean isWindows(int osId);
         /**
          * @param osId
          * @return list of supported network devices
          */
         ArrayList`<String>` getNetworkDevices(int osId, Version version);
         /**
          * @param osId
          * @param version
          * @return a specific sound device for the given os.
          */
         String getSoundDevice(int osId, Version version);
         /**
          * early windows versions require a numeric identifier for sysprep to tell
          * the timezone. In later versions this was rectified and they use a universal name.
          * @param osId
          * @param version
          * @return
          */
         boolean isTimezoneValueInteger(int osId, Version version);

### Integration with other info providers

As the info is kept as a properties, its very easy to dump external sources such as libosinfo to oVirt's format. Using libosinfo python bindings a simple script could be used to dump properties to **$ENGINE_ETC** dir. *FUTURE*: supply a python script which will harvest libosinfo db and convert it to our properties format

### Benefit to oVirt

Richer information base of OSs. Easily extended by admins using scripts/manual editing, making oVirt more configurable and extendible.

### Dependencies / Related Features

Other Host architecture such as **PPC** [1] could be added more easily as now the Os Repository can have distinction based on architecture type. Combine this with adding a new cluster architecture flag and OSs can be filtered exclusively to fit the virtualization constraints. e.g **PPC** supported OSs may have specific driver support which doesn't comply with x86. By getting all OSs which are ppc architecture, we can specify their supported device list:

      os.RHEL6.architecture = ppc
      os.RHEL6.devices.network = DEVICE_A, DEVICE_B    //list of network devices which are supported by PPC type host.

[1] [support for PPC 64 bit](/Features/Engine_support_for_PPC64|Engine)

### Testing

| Test case                                                | setup                                                                                                                               | expected                                                                                                               |
|----------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|
| 1. \*.properties files are loaded by order               | place 20-overload.properties under /etc/ovirt-engine/osinfo.conf.d                                                                  | check the logs record for loading and see values from the files are effective. Non \*.properties files are not loaded. |
| 2. Minimum memory is enforced                            | add new vm, provision memory lower than 256mb and hit OK                                                                            | you get a canDo action with the range of allowed values                                                                |
| 3. Override os.Other.resources.minimum.ram.value to 1024 | place a 20-overrload.properties with os.Other.resources.minimum.ram.value=1024 under /etc/ovirt-engine/osinfo.conf.d. Restart Jboss | repeat test case #2. values lower than 1024 should fail.                                                              |
| 4. Version value are effective                           | append to 20-overrload.properties with os.other.resources.minimum.ram.value.3.3=2042 . Restart Jboss                                | repeat test case #3 . values lower than 2042 should fail for VMs on cluster level 3.3.                                |
| 5. Add new os                                            | append to 20-overload.properties                                                                                                    

                                                            ` os.osx_10_6.id.value = 3000`                                                                                                       
                                                            ` os.osx_10_6.name.value = Snow Leopard`                                                                                             
                                                            ` os.osx_10_6.derivedFrom.value = linux`                                                                                             

                                                            Restart jboss                                                                                                                        | Edit a current VM and change its os to "Snow Leopard". Test case #2 should pass.                                      |



