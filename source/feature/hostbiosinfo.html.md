---
title: HostBiosInfo
category: feature
authors: jrankin, ybronhei
wiki_category: Feature
wiki_title: Features/Design/HostBiosInfo
wiki_revision_count: 29
wiki_last_updated: 2012-12-24
---

# Host's Bios Information

### Summary

When assigning new host to oVirt engine the engine retrieves general information about the host. This information includes Vdsm version, CPU units and inc. This article describes the bios information that the host provides to oVirt engine.

### Owner

*   Name: [ Yaniv Bronhaim](User:ybronhei)

<!-- -->

*   Email: ybronhei@redhat.com

### Current status

*   Target Release: 3.1
*   Status: Work in progress
*   Last updated date: Nov 20 2012

### Detailed Description

The following feature allows the portal to present host's bios information when adding new oVirt node.
This information is taken by using dmidecode command, this command runs with root permissions over the host and returns the information with getCapabilities API method. This adds the following data:
 1. Host Manufacturer - Manufacturer of the host's machine and bios' vendor (e.g LENOVO)

      2. Host Version - For each host the manufacturer gives a unique name (e.g. Lenovo T420s)
      3. Host Product Name - ID of the product - same for all similar products (e.g 4174BH4)
      4. Host UUID - Unique ID for each host (e.g E03DD601-5219-11CB-BB3F-892313086897)
      5. Host Family - Type of host's CPU - (e.g Core i5)
      6. Host Serial Number - Unique ID for host's chassis (e.g R9M4N4G)

Of course we can add more information in the future on request.

#### User Experience

Under Hosts tab we have general information about the chosen host. In this tab you see general information that was retrieved from the host:
![](General-tab.jpeg "fig:General-tab.jpeg")
This feature adds to this tab the following fields:
![](Bios.jpeg "fig:Bios.jpeg")

#### Engine Flows

When gathering host's capabilities we receive host's bios details by VDSM API. This information is written to the database and updates every time the host returns different response. Usually bios information stays constant. Because host capabilities are filled with dynamic data, also here we keep the dynamic flow. Engine requests are sent every refresh and update the database if needed.

#### REST API

The host's bios parameters is shown via engine rest API under host object as the following:
 <bios_information>

` `<manufacturer>`Dell Inc.`</manufacturer>
` `<version>`01`</version>
` `<serial_number>`H2CQ95J`</serial_number>
` `<product_name>`OptiPlex 790`</product_name>
` `<uuid>`4C4C4544-0032-4310-8051-C8C04F39354A`</uuid>
` `<family>`Core i7`</family>
</bios_information>

#### Engine API

Same as get host capabilities api.

#### Model

##### Error codes

#### VDSM API

Same, only that getCapabilites interface returns same structure with bios information included as part of its record.

#### Events

### Dependencies / Related Features and Projects

### Comments and Discussion

Dmidecode retrieves a lot of parameters that can be helpful also, this is all the parameters list: (If will decide to add more values, we shell consider putting the values in a new host's tab)

#### SYSTEM INFORMATION

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

#### BIOS INFORMATION

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

#### CACHE INFORMATION

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

#### PROCESSOR INFO

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

#### CHASSIS INFO

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

#### MEMORY INFO

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

### Open Issues

NA

<Category:Feature>
