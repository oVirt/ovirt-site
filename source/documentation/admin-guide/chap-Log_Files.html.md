---
title: Log Files
---

# Chapter 19: Log Files

## oVirt Engine Installation Log Files

**Installation**

| Log File | Description |
|-
| <b>/var/log/ovirt-engine/engine-cleanup_yyyy_mm_dd_hh_mm_ss.log</b> | Log from the `engine-cleanup` command. This is the command used to reset an oVirt Engine installation. A log is generated each time the command is run. The date and time of the run is used in the filename to allow multiple logs to exist. |
| <b>/var/log/ovirt-engine/engine-db-install-yyyy_mm_dd_hh_mm_ss.log</b> | Log from the `engine-setup` command detailing the creation and configuration of the <b>engine</b> database. |
| <b>/var/log/ovirt-engine/ovirt-engine-dwh-setup-yyyy_mm_dd_hh_mm_ss.log</b> | Log from the `ovirt-engine-dwh-setup` command. This is the command used to create the <b>ovirt_engine_history</b> database for reporting. A log is generated each time the command is run. The date and time of the run is used in the filename to allow multiple logs to exist concurrently. |
| <b>/var/log/ovirt-engine/setup/ovirt-engine-setup-yyyymmddhhmmss.log</b> | Log from the `engine-setup` command. A log is generated each time the command is run. The date and time of the run is used in the filename to allow multiple logs to exist concurrently. |

## oVirt Engine Log Files

**Service Activity**

| Log File | Description |
|-
| <b>/var/log/ovirt-engine/engine.log</b> | Reflects all oVirt Engine GUI crashes, Active Directory lookups, Database issues, and other events. |
| <b>/var/log/ovirt-engine/host-deploy</b> | Log files from hosts deployed from the oVirt Engine. |
| <b>/var/lib/ovirt-engine/setup-history.txt</b> | Tracks the installation and upgrade of packages associated with the oVirt Engine. |
| <b>/var/log/httpd/ovirt-requests-log</b> |Logs files from requests made to the oVirt Engine via HTTPS, including how long each request took. A `Correlation-Id` header is included to allow you to compare requests when comparing a log file with <b>/var/log/ovirt-engine/engine.log</b>. |
| <b>/var/log/ovn-provider/ovirt-provider-ovn.log</b> | Logs the activities of the OVN provider. For information about Open vSwitch logs, see the [Open vSwitch documentation](http://openvswitch.org/). |

## SPICE Log Files

SPICE log files are useful when troubleshooting SPICE connection issues. To start SPICE debugging, change the log level to `debugging`. Then, identify the log location.

Both the clients used to access the guest machines and the guest machines themselves have SPICE log files. For client side logs, if a SPICE client was launched using the native client, for which a **console.vv** file is downloaded, use the `remote-viewer` command to enable debugging and generate log output.

### SPICE Logs for Hypervisor SPICE Servers

**SPICE Logs for Hypervisor SPICE Servers**

| Log Type | Log Location | To Change Log Level: |
| Host/Hypervisor SPICE Server | `/var/log/libvirt/qemu/(guest_name).log` | Run `export SPICE_DEBUG_LEVEL=5` on the host/hypervisor prior to launching the guest.  This variable is parsed by QEMU, and if run system-wide will print the debugging information of all virtual machines on the system. This command must be run on each host in the cluster. This command works only on a per-host/hypervisor basis, not a per-cluster basis. |

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
   <td>
    <p>To run the <tt>spice-vdagentd</tt> service in debug mode, as the root user create a <b>/etc/sysconfig/spice-vdagentd</b> file with this entry: <tt>SPICE_VDAGENTD_EXTRA_ARGS=”-d -d”</tt></p>
    <p>To run <tt>spice-vdagent</tt> in debug mode, from the command line:<br>
    <pre>$ killall - u $USER spice-vdagent
$ spice-vdagent -x -d [-d] [ |& tee spice-vdagent.log ]</pre></p>
   </td>
  </tr>
 </tbody>
</table>

### SPICE Logs for SPICE Clients Launched Using console.vv Files

**For Linux client machines:**

1. Enable SPICE debugging by running the `remote-viewer` command with the `--spice-debug` option. When prompted, enter the connection URL, for example, spice://[virtual_machine_IP]:[port].

        #  remote-viewer --spice-debug

2. To view logs, download the **console.vv** file and run the `remote-viewer` command with the `--spice-debug` option and specify the full path to the **console.vv** file.

        # remote-viewer --spice-debug /path/to/console.vv

**For Windows client machines:**

1. In versions of `virt-viewer` 2.0-11.el7ev and later, **virt-viewer.msi** installs `virt-viewer` and `debug-viewer.exe`.

2. Run the `remote-viewer` command with the `spice-debug` argument and direct the command at the path to the console:

        remote-viewer --spice-debug path\to\console.vv

3. To view logs, connect to the virtual machine, and you will see a command prompt running GDB that prints standard output and standard error of `remote-viewer`.

## Host Log Files

| Log File | Description |
|-
| <b>/var/log/messages</b> | The log file used by `libvirt`. Use `journalctl` to view the log. You must be a member of the <em>adm</em>, <em>systemd-journal</em>, or <em>wheel</em> groups to view the log. |
| <b>/var/log/vdsm/spm-lock.log</b> | Log file detailing the host's ability to obtain a lease on the Storage Pool Manager role. The log details when the host has acquired, released, renewed, or failed to renew the lease. |
| <b>/var/log/vdsm/vdsm.log</b> | Log file for VDSM, the Engine's agent on the host(s). |
| <b>/tmp/ovirt-host-deploy-@DATE@.log</b> | A host deployment log that is copied to the Engine as <b>/var/log/ovirt-engine/host-deploy/ovirt-_Date-Host-Correlation_ID.log_</b> after the host has been successfully deployed. |
| <b>/var/log/vdsm/import/import-@UUID-Date@.log</b> | Log file detailing virtual machine imports from a KVM host, a VMWare provider, or a Xen host, including import failure information. `UUID` is the UUID of the virtual machine that was imported and `Date` is the date and time that the import began. |
| <b>/var/log/vdsm/supervdsm.log</b> | Logs VDSM tasks that were executed with superuser permissions. |
| <b>/var/log/vdsm/upgrade.log</b> | VDSM uses this log file during host upgrades to log configuration changes. |
| <b>/var/log/vdsm/mom.log</b> | Logs the activities of the VDSM’s memory overcommitment manager. |

## Setting Up a Host Logging Server

Hosts generate and update log files, recording their actions and problems. Collecting these log files centrally simplifies debugging.

This procedure should be used on your centralized log server. You could use a separate logging server, or use this procedure to enable host logging on the oVirt Engine.

**Setting up a Host Logging Server**

1. Configure SELinux to allow `rsyslog` traffic.

        # semanage port -a -t syslogd_port_t -p udp 514

2. Edit `/etc/rsyslog.conf` and add the following lines:

        $template TmplAuth, "/var/log/%fromhost%/secure"
        $template TmplMsg, "/var/log/%fromhost%/messages"

        $RuleSet remote
        authpriv.*   ?TmplAuth
        \*.info,mail.none;authpriv.none,cron.none   ?TmplMsg
        $RuleSet RSYSLOG_DefaultRuleset
        $InputUDPServerBindRuleset remote

    Uncomment the following:

        #$ModLoad imudp
        #$UDPServerRun 514

3. Restart the rsyslog service:

        # systemctl restart rsyslog.service

Your centralized log server is now configured to receive and store the `messages` and `secure` logs from your virtualization hosts.

**Prev:** [Chapter 18: Utilities](chap-Utilities)<br>
**Next:** [Chapter 20: Proxies](chap-Proxies)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/chap-log_files)
