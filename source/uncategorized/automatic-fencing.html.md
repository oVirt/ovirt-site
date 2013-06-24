---
title: Automatic Fencing
authors: emesika, mperina, ofrenkel, tscofield, ybronhei
wiki_title: Automatic Fencing
wiki_revision_count: 14
wiki_last_updated: 2015-05-25
---

# Automatic Fencing

oVirt engine can automatically fence hosts that fail to respond. In order for fencing to run, there are 3 requirements:

1.  Fencing is configured and enabled on the host.
2.  There is a valid proxy host (another host in the same data-center in UP status).
3.  Connection to the host has timed out:
    -   On **first** network failure, host status will change to **connecting**
    -   Then engine will try 3 times more to ask vdsm for status (configuration: VDSAttemptsToResetCount) or wait an interval of time that depends on host's load (configured by the the config values TimeoutToResetVdsInSeconds[deafult 60sec] + (DelayResetPerVmInSeconds[default 0.5sec]\*(the count of running vms on host) + (DelayResetForSpmInSeconds[default 20sec]\*(1 if host runs as SPM or 0 if not)).)
    -   **The longer of which** - for example if vdsm hangs then 3 times may take up to 9 mins
    -   If the host doesn't respond during this time, it's status will change to **non responsive** and it will be fenced.

more information:

*   in case fencing fails (couldn't restart the host for example) there is no retry, host will stay in non-responsive status.
*   during engine startup fencing is disabled, there is a configuration to set the time from the startup in which fencing is disabled: 'DisableFenceAtStartupInSec' default is 300 seconds
*   once host is rebooted, it's status is moved to reboot for configurable time: 'ServerRebootTimeout' default is 300 seconds

# Automatic Fencing in oVirt 3.3

Fencing process in oVirt 3.3 has been extended of **SSH Soft Fencing** prior to real fencing. **SSH Soft Fencing** tries to restart VDSM using SSH connection. The executed command can be configured in SshSoftFencingCommand per cluster level. The fencing process is based on this flow:

1.  Fencing is configured and enabled on the host.
2.  There is a valid proxy host (another host in the same data-center in UP status).
3.  Connection to the host has timed out:
    -   On **first** network failure, host status will change to **connecting**
    -   Then engine will try 3 times more to ask vdsm for status (configuration: VDSAttemptsToResetCount) or wait an interval of time that depends on host's load (configured by the the config values TimeoutToResetVdsInSeconds[deafult 60sec] + (DelayResetPerVmInSeconds[default 0.5sec]\*(the count of running vms on host) + (DelayResetForSpmInSeconds[default 20sec]\*(1 if host runs as SPM or 0 if not)).)
    -   **The longer of which** - for example if vdsm hangs then 3 times may take up to 9 mins
    -   If the host doesn't respond during this time, execute VDSM restart using SSH connection. If command execution hasn't been successful, fence the host immediately.
    -   Wait if host recovers for previously specified time (ask 3 times VDSM for status or wait an interval of time that depends on host's load)
    -   If the host doesn't respond during this time, it's status will change to **non responsive** and it will be fenced.

# Troubleshooting

Check that you can run the fence agent from the command line. Use the fence script that corresponds with the fence type you are setting up.

*   fence_drac5
    -   When testing make sure to use the "--action=status" parameter.
    -   The secure option in ovirt is equivalent to the "-- ssh" command line
    -   Verify the command prompt, Drac 6 requires a "--command-prompt=admin" parameter, note the command line parameter and the STDIN parameter are different for this option
    -   If your drac is slow to respond try adding a login-timeout option
