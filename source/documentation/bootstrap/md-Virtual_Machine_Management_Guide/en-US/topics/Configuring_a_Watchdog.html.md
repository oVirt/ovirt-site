# Installing a Watchdog

To activate a watchdog card attached to a virtual machine, you must install the `watchdog` package on that virtual machine and start the `watchdog` service.

**Installing Watchdogs**

1. Log in to the virtual machine on which the watchdog card is attached.

2. Install the `watchdog` package and dependencies:

        # yum install watchdog

3. Edit the `/etc/watchdog.conf` file and uncomment the following line:

        watchdog-device = /dev/watchdog

4. Save the changes.

5.  Start the `watchdog` service and ensure this service starts on boot:

    * Red Hat Enterprise Linux 6: 
   
            # service watchdog start
            # chkconfig watchdog on

    * Red Hat Enterprise Linux 7: 
   
            # systemctl start watchdog.service
            # systemctl enable watchdog.service
