---
title: Connect to Guest Display
authors: dougsland
---

<!-- TODO: Content review -->

# Connect to Guest Display

## Spice

### Yum Repositories
First install spice-xpi extension for Firefox

        # yum install spice-xpi
        <restart firefox>
        Go to Virtual Machine Tab, right click on VM and select Console

*   Tested:
    -   Firefox 3.6.24 - spice-xpi-2.4-4.el6.x86_64 - RHEL6
    -   -   -   fell free to contribute here \*\*\*\*
    
### Debian Repositories
First install browser-plugin-xpi

        # apt install browser-plugin-xpi
        <restart firefox>
        Go to Virtual Machine Tab, right click on VM and select Console

*   Tested:
    -   Firefox Quantum 63.03 (64-bit) | browser-plugin-spice_2.8.90-5_amd64.deb | LXQt 0.13.0

## VNC

*   Setting manually the vnc password

1) Get VM id and displayPort data

        # vdsClient -s 0 list

2) Setting vnc password to VM

        # vdsClient -s 0 setVmTicket <vmid> <password> 0 keep

3) Now try to use vnc client

        # vncviewer <OVIRT_NODE_IP>:<displayPort>
