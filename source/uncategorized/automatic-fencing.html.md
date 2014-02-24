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

### SSH Soft Fencing

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

Attention: SSH Soft Fencing is also executed on hosts without power management configured unlike real fencing that is executed only for hosts with power management configured.

### Testing

I used following scenario to test SSH Soft Fencing for hosts with PM configured:

1.  Create a 3.3 data center, create a cluster in it and add two hosts to it with PM properly configured
2.  Testing scenario: SSH Soft Fencing will help and host will change status to Up after it
    1.  Stop engine, connect to engine database and check if "SshSoftFencingCommand" option is set to correct value "/usr/bin/vdsm-tool service-restart vdsmd" using following SQL command: `select * from vdc_options where option_name='SshSoftFencingCommand' and version='3.3'`
    2.  If the value is different, please correct it with SQL command: `update vdc_options set option_value='/usr/bin/vdsm-tool service-restart vdsmd' where option_name='SshSoftFencingCommand' and version='3.3'`
    3.  Start engine
    4.  Check if both hosts are Up
    5.  Stop VDSM on selected host
    6.  Wait a few minutes to see if host status changes to Up

3.  Testing scenario: SSH Soft Fencing command throws error on execution, real fencing will start immediately after it
    1.  Stop engine
    2.  Connect to engine database and execute following SQL command: `update vdc_options set option_value='servi vdsmd restart' where option_name='SshSoftFencingCommand' and version='3.3'`
    3.  Start engine and check if both hosts are Up
    4.  Stop VDSM on selected host
    5.  After a few minutes SSH Soft Fencing command error appears in engine.log and real fencing (server restart) will be executed for selected host immediately
    6.  After restart host will become Up

4.  Testing scenario: SSH Soft Fencing will not help, real fencing will be executed in few minutes after SSH Soft Fencing execution
    1.  Stop engine
    2.  Connect to engine database and execute following SQL command: `update vdc_options set option_value='echo 0' where option_name='SshSoftFencingCommand' and version='3.3'`
    3.  Start engine and check if both hosts are Up
    4.  Stop VDSM on selected host
    5.  After a few minutes SSH Soft Fencing command will be executed, but the host will remain Non Responsive
    6.  After another few minutes real fencing (server restart) will be executed for selected host
    7.  After restart host will become Up

I used following scenario to test SSH Soft Fencing for hosts without PM configured:

1.  Create a 3.3 data center, create a cluster in it and add two hosts to it without PM properly configured
2.  Testing scenario: SSH Soft Fencing will help and host will change status to Up after it
    1.  Stop engine, connect to engine database and check if "SshSoftFencingCommand" option is set to correct value "/usr/bin/vdsm-tool service-restart vdsmd" using following SQL command: `select * from vdc_options where option_name='SshSoftFencingCommand' and version='3.3'`
    2.  If the value is different, please correct it with SQL command: `update vdc_options set option_value='/usr/bin/vdsm-tool service-restart vdsmd' where option_name='SshSoftFencingCommand' and version='3.3'`
    3.  Start engine
    4.  Check if both hosts are Up
    5.  Stop VDSM on selected host
    6.  Wait a few minutes to see if host status changes to Up

3.  Testing scenario: SSH Soft Fencing will not help, host stays Non Responsive after it
    1.  Stop engine
    2.  Connect to engine database and execute following SQL command: `update vdc_options set option_value='echo 0' where option_name='SshSoftFencingCommand' and version='3.3'`
    3.  Start engine and check if both hosts are Up
    4.  Stop VDSM on selected host
    5.  After a few minutes SSH Soft Fencing command will be executed, but the host will remain Non Responsive

# Automatic Fencing in oVirt 3.5

*It's only proposal, not yet finalized!*

Automatic fencing flow will be extended in oVirt 3.5:

1.  SSH Soft Fencing can be turned on/off for each host in Power Management tab in Add/Edit host dialog
2.  SSH Soft Fencing will be turned on by default. *Will it be beneficial to set default per cluster/DC, so admin won't be forced to set it on each host?*
3.  Support for fence_kdump will be included (more details in [Fence kdump](Fence kdump))

Fencing flow in oVirt 3.5 will be defined as this:

1.  On first network failure, host status will change to **Connecting**
2.  Then engine will try 3 times more to ask vdsm for status (configuration: `VDSAttemptsToResetCount`) or wait an interval of time that depends on host's load (configured by the the config values `TimeoutToResetVdsInSeconds` + (`DelayResetPerVmInSeconds` \* (the count of running vms on host) + (`DelayResetForSpmInSeconds` \* (1 if host runs as SPM or 0 if not)).)
3.  If the host doesn't respond during this time, execute VDSM restart using SSH connection. If command execution wasn't successful, proceed to fence kdump step immediately.
4.  Wait if host recovers for previously specified time (ask 3 times VDSM for status or wait an interval of time that depends on host's load) If the host doesn't respond during this time, it's status will change to **Non responsive** and fence kdump step will be executed.
5.  If fence kdump is enabled for the host, check if fence kdump message will be received. If message is received, set host status to **Reboot** and exit from fencing flow.
6.  If message from **Non responsive** host is not received in specified timeout (`FenceKdumpMessageTimeout`), proceed to hard fencing step.
7.  If hard fencing is configured for host, execute it. Otherwise exit from fencing flow

# Troubleshooting

Check that you can run the fence agent from the command line. Use the fence script that corresponds with the fence type you are setting up.

*   fence_drac5
    -   When testing make sure to use the "--action=status" parameter.
    -   The secure option in ovirt is equivalent to the "-- ssh" command line
    -   Verify the command prompt, Drac 6 requires a "--command-prompt=admin" parameter, note the command line parameter and the STDIN parameter are different for this option
    -   If your drac is slow to respond try adding a login-timeout option
