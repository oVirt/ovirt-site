# Confirming Watchdog Functionality

Confirm that a watchdog card has been attached to a virtual machine and that the `watchdog` service is active.

**Warning:** This procedure is provided for testing the functionality of watchdogs only and must not be run on production machines.

**Confirming Watchdog Functionality**

1. Log in to the virtual machine on which the watchdog card is attached.

2. Confirm that the watchdog card has been identified by the virtual machine:

        # lspci | grep watchdog -i

3. Run one of the following commands to confirm that the watchdog is active:

    * Trigger a kernel panic:

            # echo c > /proc/sysrq-trigger

    * Terminate the `watchdog` service:

            # kill -9 `pgrep watchdog`

The watchdog timer can no longer be reset, so the watchdog counter reaches zero after a short period of time. When the watchdog counter reaches zero, the action specified in the **Watchdog Action* drop-down menu for that virtual machine is performed.

