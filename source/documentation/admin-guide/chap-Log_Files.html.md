---
title: Log Files
---

# Chapter 19: Log Files

## oVirt Engine Installation Log Files

**Installation**

| Log File | Description |
|-
| `/var/log/ovirt-engine/engine-cleanup_yyyy_mm_dd_hh_mm_ss.log` | Log from the `engine-cleanup` command. This is the command used to reset an oVirt Engine installation. A log is generated each time the command is run. The date and time of the run is used in the filename to allow multiple logs to exist. |
| `/var/log/ovirt-engine/engine-db-install-yyyy_mm_dd_hh_mm_ss.log` | Log from the `engine-setup` command detailing the creation and configuration of the `rhevm` database. |
| `/var/log/ovirt-engine/ovirt-engine-dwh-setup-yyyy_mm_dd_hh_mm_ss.log` | Log from the `ovirt-engine-dwh-setup` command. This is the command used to create the `ovirt_engine_history` database for reporting. A log is generated each time the command is run. The date and time of the run is used in the filename to allow multiple logs to exist concurrently. |
| `/var/log/ovirt-engine/setup/ovirt-engine-setup-yyyymmddhhmmss.log` | Log from the `engine-setup` command. A log is generated each time the command is run. The date and time of the run is used in the filename to allow multiple logs to exist concurrently. |

## oVirt Engine Log Files

**Service Activity**

| Log File | Description |
|-
| `/var/log/ovirt-engine/engine.log` | Reflects all oVirt Engine GUI crashes, Active Directory lookups, Database issues, and other events. |
| `/var/log/ovirt-engine/host-deploy` | Log files from hosts deployed from the oVirt Engine. |
| `/var/lib/ovirt-engine/setup-history.txt` | Tracks the installation and upgrade of packages associated with the oVirt Engine. |

## SPICE Log Files

SPICE log files are useful when troubleshooting SPICE connection issues. To start SPICE debugging, change the log level to `debugging`. Then, identify the log location.

Both the clients used to access the guest machines and the guest machines themselves have SPICE log files. For client side logs, if a SPICE client was launched using the native client, for which a `console.vv` file is downloaded, use the `remote-viewer` command to enable debugging and generate log output.

### SPICE Logs for Hypervisor SPICE Servers

**SPICE Logs for Hypervisor SPICE Servers**

| Log Type | Log Location | To Change Log Level: |
| Host/Hypervisor SPICE Server | `/var/log/libvirt/qemu/(guest_name).log` | Run `export SPICE_DEBUG_LEVEL=5` on the host/hypervisor prior to launching the guest. |

### SPICE Logs for Guest Machines

**SPICE Logs for Guest Machines**

<table>
 <thead>
  <tr>
   <td>Log Type</td>
   <td>Log Location</td>
   <td>To Change Log Level:</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>Windows Guest</td>
   <td>
    <p>C:\Windows\Temp\vdagent.log</p>
    <p>C:\Windows\Temp\vdservice.log</p>
   </td>
   <td>Not applicable</td>
  </tr>
  <tr>
   <td>Enterprise Linux Guest</td>
   <td>/var/log/spice-vdagent.log</td>
   <td>Create a <tt>/etc/sysconfig/spice-vdagentd</tt> file with this entry: <tt>SPICE_VDAGENTD_EXTRA_ARGS=”-d -d”</tt></td>
  </tr>
 </tbody>
</table>

### SPICE Logs for SPICE Clients Launched Using console.vv Files

**For Linux client machines:**

1. Enable SPICE debugging by running the `remote-viewer` command with the `--spice-debug` option. When prompted, enter the connection URL, for example, spice://[virtual_machine_IP]:[port].

        #  remote-viewer --spice-debug

2. To view logs, download the `console.vv` file and run the `remote-viewer` command with the `--spice-debug` option and specify the full path to the `console.vv` file.

        # remote-viewer --spice-debug /path/to/console.vv

**For Windows client machines:**

1. Download the `debug-helper.exe` file and move it to the same directory as the `remote-viewer.exe` file. For example, the `C:\Users\[user name]\AppData\Local\virt-viewer\bin` directory.

2. Execute the `debug-helper.exe` file to install the GNU Debugger (GDB).

3. Enable SPICE debugging by executing the `debug-helper.exe` file.

        debug-helper.exe remote-viewer.exe --spice-controller

4. To view logs, connect to the virtual machine, and you will see a command prompt running GDB that prints standard output and standard error of `remote-viewer`.

## oVirt Node Log Files

| Log File | Description |
|-
| `/var/log/vdsm/libvirt.log` | Log file for `libvirt`. |
| `/var/log/vdsm/spm-lock.log` | Log file detailing the host's ability to obtain a lease on the Storage Pool Manager role. The log details when the host has acquired, released, renewed, or failed to renew the lease. |
| `/var/log/vdsm/vdsm.log` | Log file for VDSM, the Manager's agent on the virtualization host(s). |
| `/tmp/ovirt-host-deploy-@DATE@.log` | Host deployment log, copied to engine as `/var/log/ovirt-engine/host-deploy/ovirt-@DATE@-@HOST@-@CORRELATION_ID@.log` after the host has been successfully deployed. |

## Setting Up a Virtualization Host Logging Server

Hosts generate and update log files, recording their actions and problems. Collecting these log files centrally simplifies debugging.

This procedure should be used on your centralized log server. You could use a separate logging server, or use this procedure to enable host logging on the oVirt Engine.

**Setting up a Virtualization Host Logging Server**

1. Configure SELinux to allow `rsyslog` traffic.

        # semanage port -a -t syslogd_port_t -p udp 514

2. Edit `/etc/rsyslog.conf` and add the following lines:

        $template TmplAuth, "/var/log/%fromhost%/secure"
        $template TmplMsg, "/var/log/%fromhost%/messages"

        $RuleSet remote
        authpriv.*   ?TmplAuth
        *.info,mail.none;authpriv.none,cron.none   ?TmplMsg
        $RuleSet RSYSLOG_DefaultRuleset
        $InputUDPServerBindRuleset remote

    Uncomment the following:

        #$ModLoad imudp
        #$UDPServerRun 514

3. Restart the rsyslog service:

        # systemctl restart rsyslog.service

Your centralized log server is now configured to receive and store the `messages` and `secure` logs from your virtualization hosts.

**Prev:** [Chapter 18: Utilities](../chap-Utilities)<br>
**Next:** [Chapter 20: Proxies](../chap-Proxies)
