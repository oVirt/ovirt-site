---
title: HostHardwareInfo
category: feature
authors: sandrobonazzola, ybronhei
---

# Host's Hardware Information

## Summary

When assigning new host to oVirt engine the engine retrieves general information about the host. This information includes Vdsm version, CPU units and inc. This article describes the hardware information that the host provides to oVirt engine.

## Owner

*   Name: Yaniv Bronhaim (ybronhei)



## Current status

*   Target Release: 3.2
*   Status: Work In Progress
*   Last updated date: Nov 20 2012

## Detailed Description

The following feature allows the user interface to present host's hardware information when adding new hypervisor.
This information is taken by using dmidecode command, this command runs with root permissions over the host and returns the information with getVdsHardwareInfo API method. This returns the following fields[1]:

```
1. Host Manufacturer - Manufacturer of the host's machine and hardware' vendor (e.g LENOVO)
2. Host Version - For each host the manufacturer gives a unique name (e.g. Lenovo T420s)
3. Host Product Name - ID of the product - same for all similar products (e.g 4174BH4)
4. Host UUID - Unique ID for each host (e.g E03DD601-5219-11CB-BB3F-892313086897)
5. Host Family - Type of host's CPU - (e.g Core i5)
6. Host Serial Number - Unique ID for host's chassis (e.g R9M4N4G)
```

The following parameters below are suggested to be added:

```
7. BIOS Revision
8. BIOS Version
9. BIOS is upgradable
10. BIOS Vendor
11. BIOS Release Date

12. Processor Version
13. Processor Core Count
14. Processor Vendor
15. Processor Core Enabled
16. Processor Current Speed
17. Processor Max Speed
18. Processor Thread Count

19. Chassis Asset Tag
20. Chassis Serial Number
21. Chassis Manufacturer

22. Memory Serial Number
23. Memory Total Width
24. Memory Number of Devices
25. Memory Manufacturer
26. Memory Data Width
27. Memory Error Correction Type
28. Memory Maximum Capacity
29. Memory Type Detail
30. Memory Speed
31. Memory Size
```

[1] More parameters can be added on request.

### User Experience

Under Hosts tab we have general information about the chosen host. In this tab you see general information that was retrieved from the host:
![](/images/wiki/General-tab.png)

This feature adds new host's sub-tab called Hardware Information. Hardware Information will display the following fields:
![](/images/wiki/Bios.png)

### VDSM Flow

When Vdsm receives getVdsHardwareInfo request, it retrieves the hardware information by using python-dmidecode utility. After collecting and arranging the information, Vdsm delivers it to engine by xml rpc.

### Engine Flow

When refreshing host's capabilities we call to getVdsHardwareInfo, On update this information is written to the database to vds_dynamic table with other all host information.

----
Short explanation about vds tables:

We have 3 tables that engine works with - `vds_static`, `vds_dynamic`, `vds_statistics`, all goes to one view that is called VDS.

* `vds_statistics` includes fields that get updated every 2 sec (highest frequency)
* `vds_static` includes fields that get changed threw the UI like IP, CPU Cores (that can be specified by the user) and more configurable data.
* `vds_dynamic` includes host information that retrieved from specific vds

Hardware information needs to be part of the vds dynamic information and retrieved in constants intervals or cases by API request from host (as get capabilities)

----
 This information is mapped to Vds entity and kept there, when mapping to UI we use those parameters to build the Host entity.

### REST API

The host's Hardware parameters is shown via engine rest API under host object as the following:
```xml
<hardware_information>
   <manufacturer>Dell Inc.</manufacturer>
   <version>01</version>
   <serial_number>H2CQ95J</serial_number>
   <product_name>OptiPlex 790</product_name>
   <uuid>4C4C4544-0032-4310-8051-C8C04F39354A</uuid>
   <family>Core i7</family>
</hardware_information>
```

## dmidecode Output

### System Information

```
dmi_type - 1
SKU Number - Not Specified
UUID - E03DD601-5219-11CB-BB3F-892313086897
Family - ThinkPad T420s
Serial Number - R9M4N4G
Version - ThinkPad T420s
Wake-Up Type - Power Switch
Product Name - 4174BH4
dmi_handle - 0x0010
dmi_size - 27
Manufacturer - LENOVO
```

### Bios Information

```
NEC PC-98 - False
EDD is supported - True
PC Card (PCMCIA) is supported - False
I2O boot - False
3.5"/2.88 MB floppy services are supported (int 13h) - False
BIOS Revision - 1.31
ATAPI Zip drive boot - False
Version - 8CET51WW (1.31 )
BIOS is upgradeable - True
Smart battery - False
8042 keyboard services are supported (int 9h) - True
BIOS shadowing is allowed - True
BIOS ROM is socketed - False
USB legacy - True
APM is supported - False
AGP - False
PNP is supported - True
VLB is supported - False
Vendor - LENOVO
ISA is supported - False
Japanese floppy for Toshiba 1.2 MB is supported (int 13h) - False
CGA/mono video services are supported (int 10h) - True
Serial services are supported (int 14h) - True
5.25"/360 KB floppy services are supported (int 13h) - False
Address - 0xe0000
ROM Size - 8192 KB
Function key-initiated network boot - True
Currently Installed Language - ['en-US']
Runtime Size - 128 KB
Targeted content distribution - False
3.5"/720 KB floppy services are supported (int 13h) - True
Relase Date - 11/29/2011
BIOS boot specification - True
MCA is supported - False
PCI is supported - True
5.25"/1.2 MB floppy services are supported (int 13h) - False
dmi_handle - 0x002d
Selectable boot is supported - True
dmi_type - 13
Japanese floppy for NEC 9800 1.2 MB is supported (int 13h) - False
EISA is supported - False
Print screen service is supported (int 5h) - True
Boot from PC Card (PCMCIA) is supported - False
Printer services are supported (int 17h) - True
ESCD support is available - False
dmi_size - 22
Boot from CD is supported - True
Installed Languages - 1
ACPI - True
LS-120 boot - False
IEEE 1394 boot - False
```

### Cache Information

```
dmi_type - 7
System Type - Data
Socket Designation - L2-Cache
Installed SRAM Type - [None, None, None, None, None, 'Synchronous', None]
Level - 2
Socketed - False
Associativity - 8-way Set-associative
Supported SRAM Type - [None, None, None, None, None, 'Synchronous', None]
Enabled - True
Maximum Size - 256 KB
dmi_handle - 0x0003v Installed Size - 256 KB
Location - Internal
Error Correction Type - Single-bit ECC
Speed - Unknown
Operational Mode - Write Through
dmi_size - 19
```

### Processor Information

```
Upgrade - ZIF Socket
Socket Designation - CPU
L2 Cache Handle - 0x0003
Version - Intel(R) Core(TM) i5-2540M CPU @ 2.60GHz
Type - Central Processor
Core Count - 2
Status - Populated:Enabled
Vendor - Intel(R) Corporation
Core Enabled - 2
dmi_handle - 0x0001
External Clock - 100
Serial Number - Not Supported by CPU
Current Speed - 2600
dmi_size - 42
L3 Cache Handle - 0x0004
Part Number - None
Asset Tag - None
Signature - None
L1 Cache Handle - 0x0002
ID - a7 06 02 00 ff fb eb bf
dmi_type - 4
Family -
Characteristics - ['64-bit capable']
Voltage - 1.2 V
Max Speed - 2600
Thread Count - 4
```

### Chassis Information

```
dmi_type - 3
Type - Notebook
Power Supply State - Unknown
Thermal State - Unknown
Asset Tag - RH0003183
Serial Number - R9M4N4G
Version - Not Available
Lock - Not Present
Security Status - Unknown
Boot-Up State - Unknown
dmi_handle - 0x0012
dmi_size - 21
Manufacturer - LENOVO
```

### Memory Information

```
Use - System Memory
Location - System Board Or Motherboard
Type -
Array Handle - 0x0005
Number Of Devices - 2
Serial Number - 340F5D7F
Total Width - 64 bit
Form Factor - SODIMM
dmi_size - 15
Manufacturer - Kingston
Data Width - 64 bit
Part Number - 99U5428-046.A00LF
AssetTag - 9876543210
Bank Locator - BANK 2
Error Correction Type - None
dmi_handle - 0x0005
dmi_type - 16
Maximum Capacity - 16 GB
Set - None
Error Information Handle - Not Provided
Locator - ChannelB-DIMM0
Type Detail - [None, None, None, None, None, None, 'Synchronous', None, None, None, None, None]
Speed - 1333 MHz (0.8ns)
Size - 4096 MB
```

[HostHardwareInfo](/develop/release-management/features/) [HostHardwareInfo](/develop/release-management/releases/3.2/feature.html)
