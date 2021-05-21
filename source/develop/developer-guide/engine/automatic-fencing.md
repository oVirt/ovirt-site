---
title: Automatic Fencing
authors:
  - emesika
  - mperina
  - ofrenkel
  - tscofield
  - ybronhei
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

## SSH Soft Fencing

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

## Testing

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

Support for host kdump detection using fence_kdump will be inserted into current fencing flow just before hard fencing, details are in [Fencing flow with fence_kdump](/develop/release-management/features/infra/fence-kdump.html#fencing-flow-with-fence_kdump).

# Troubleshooting

Check that you can run the fence agent from the command line. Use the fence script that corresponds with the fence type you are setting up.

*   All agents

fence-agents package removed support of sending boolean flags by their own, so, if you are using in your fence agent option field any flag, you should give it a '1' value For example, instead of "ssh,lanplus" , you should write "ssl=1,lanplus=1"

*   fence_drac5
    -   When testing make sure to use the "--action=status" parameter.
    -   The secure option in ovirt is equivalent to the "-- ssh" command line
    -   Verify the command prompt, Drac 6 requires a "--command-prompt=admin" parameter, note the command line parameter and the STDIN parameter are different for this option
    -   If your drac is slow to respond try adding a login-timeout option
