# Red Hat Virtualization Host Log Files

| Log File | Description |
|-
| `/var/log/vdsm/libvirt.log` | Log file for `libvirt`. |
| `/var/log/vdsm/spm-lock.log` | Log file detailing the host's ability to obtain a lease on the Storage Pool Manager role. The log details when the host has acquired, released, renewed, or failed to renew the lease. |
| `/var/log/vdsm/vdsm.log` | Log file for VDSM, the Manager's agent on the virtualization host(s). |
| `/tmp/ovirt-host-deploy-@DATE@.log` | Host deployment log, copied to engine as `/var/log/ovirt-engine/host-deploy/ovirt-@DATE@-@HOST@-@CORRELATION_ID@.log` after the host has been successfully deployed. |
