# Red Hat Virtualization Manager Installation Log Files

**Installation**

| Log File | Description |
|-
| `/var/log/ovirt-engine/engine-cleanup_yyyy_mm_dd_hh_mm_ss.log` | Log from the `engine-cleanup` command. This is the command used to reset a Red Hat Virtualization Manager installation. A log is generated each time the command is run. The date and time of the run is used in the filename to allow multiple logs to exist. |
| `/var/log/ovirt-engine/engine-db-install-yyyy_mm_dd_hh_mm_ss.log` | Log from the `engine-setup` command detailing the creation and configuration of the `rhevm` database. |
| `/var/log/ovirt-engine/ovirt-engine-dwh-setup-yyyy_mm_dd_hh_mm_ss.log` | Log from the `ovirt-engine-dwh-setup` command. This is the command used to create the `ovirt_engine_history` database for reporting. A log is generated each time the command is run. The date and time of the run is used in the filename to allow multiple logs to exist concurrently. |
| `/var/log/ovirt-engine/setup/ovirt-engine-setup-yyyymmddhhmmss.log` | Log from the `engine-setup` command. A log is generated each time the command is run. The date and time of the run is used in the filename to allow multiple logs to exist concurrently. |
