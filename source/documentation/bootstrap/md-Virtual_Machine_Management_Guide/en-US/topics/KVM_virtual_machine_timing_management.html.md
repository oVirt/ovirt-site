# KVM virtual machine timing management

Virtualization poses various challenges for virtual machine time keeping. Virtual machines which use the Time Stamp Counter (TSC) as a clock source may suffer timing issues as some CPUs do not have a constant Time Stamp Counter. Virtual machines running without accurate timekeeping can have serious affects on some networked applications as your virtual machine will run faster or slower than the actual time.

KVM works around this issue by providing virtual machines with a paravirtualized clock. The KVM `pvclock` provides a stable source of timing for KVM guests that support it.

Presently, only Red Hat Enterprise Linux 5.4 and higher virtual machines fully support the paravirtualized clock.

Virtual machines can have several problems caused by inaccurate clocks and counters:

* Clocks can fall out of synchronization with the actual time which invalidates sessions and affects networks.

* Virtual machines with slower clocks may have issues migrating.

These problems exist on other virtualization platforms and timing should always be tested.

**Important:** The Network Time Protocol (NTP) daemon should be running on the host and the virtual machines. Enable the `ntpd` service and add it to the default startup sequence:

* For Red Hat Enterprise Linux 6 

        # service ntpd start
        # chkconfig ntpd on

* For Red Hat Enterprise Linux 7 

        # systemctl start ntpd.service
        # systemctl enable ntpd.service

Using the `ntpd` service should minimize the affects of clock skew in all cases.

The NTP servers you are trying to use must be operational and accessible to your hosts and virtual machines.

**Determining if your CPU has the constant Time Stamp Counter**

Your CPU has a constant Time Stamp Counter if the `constant_tsc` flag is present. To determine if your CPU has the `constant_tsc` flag run the following command:

    $ cat /proc/cpuinfo | grep constant_tsc

If any output is given your CPU has the `constant_tsc` bit. If no output is given follow the instructions below.

**Configuring hosts without a constant Time Stamp Counter**

Systems without constant time stamp counters require additional configuration. Power management features interfere with accurate time keeping and must be disabled for virtual machines to accurately keep time with KVM.

**Important:** These instructions are for AMD revision F CPUs only.

If the CPU lacks the `constant_tsc` bit, disable all power management features ([BZ#513138](https://bugzilla.redhat.com/show_bug.cgi?id=513138)). Each system has several timers it uses to keep time. The TSC is not stable on the host, which is sometimes caused by `cpufreq` changes, deep C state, or migration to a host with a faster TSC. Deep C sleep states can stop the TSC. To prevent the kernel using deep C states append "`processor.max_cstate=1`" to the kernel boot options in the `grub.conf` file on the host:

    term Red Hat Enterprise Linux Server (2.6.18-159.el5)
            root (hd0,0)
     kernel /vmlinuz-2.6.18-159.el5 ro root=/dev/VolGroup00/LogVol00 rhgb quiet processor.max_cstate=1

Disable `cpufreq` (only necessary on hosts without the `constant_tsc`) by editing the `/etc/sysconfig/cpuspeed` configuration file and change the `MIN_SPEED` and `MAX_SPEED` variables to the highest frequency available. Valid limits can be found in the `/sys/devices/system/cpu/cpu*/cpufreq/scaling_available_frequencies` files.

**Using the `engine-config` tool to receive alerts when hosts drift out of sync.**

You can use the `engine-config` tool to configure alerts when your hosts drift out of sync.

There are 2 relevant parameters for time drift on hosts: `EnableHostTimeDrift` and `HostTimeDriftInSec`. `EnableHostTimeDrift`, with a default value of false, can be enabled to receive alert notifications of host time drift. The `HostTimeDriftInSec` parameter is used to set the maximum allowable drift before alerts start being sent.

Alerts are sent once per hour per host.

**Using the paravirtualized clock with Red Hat Enterprise Linux virtual machines**

For certain Red Hat Enterprise Linux virtual machines, additional kernel parameters are required. These parameters can be set by appending them to the end of the /kernel line in the /boot/grub/grub.conf file of the virtual machine.

**Note:** The process of configuring kernel parameters can be automated using the `ktune` package

The `ktune` package provides an interactive Bourne shell script, `fix_clock_drift.sh`. When run as the superuser, this script inspects various system parameters to determine if the virtual machine on which it is run is susceptible to clock drift under load. If so, it then creates a new `grub.conf.kvm` file in the `/boot/grub/` directory. This file contains a kernel boot line with additional kernel parameters that allow the kernel to account for and prevent significant clock drift on the KVM virtual machine. After running `fix_clock_drift.sh` as the superuser, and once the script has created the `grub.conf.kvm` file, then the virtual machine's current `grub.conf` file should be backed up manually by the system administrator, the new `grub.conf.kvm` file should be manually inspected to ensure that it is identical to `grub.conf` with the exception of the additional boot line parameters, the `grub.conf.kvm` file should finally be renamed `grub.conf`, and the virtual machine should be rebooted.

The table below lists versions of Red Hat Enterprise Linux and the parameters required for virtual machines on systems without a constant Time Stamp Counter.

| Red Hat Enterprise Linux | Additional virtual machine kernel parameters |
|-
| 5.4 AMD64/Intel 64 with the paravirtualized clock | Additional parameters are not required |
| 5.4 AMD64/Intel 64 without the paravirtualized clock | notsc lpj=n |
| 5.4 x86 with the paravirtualized clock | Additional parameters are not required |
| 5.4 x86 without the paravirtualized clock | clocksource=acpi_pm lpj=n |
| 5.3 AMD64/Intel 64 | notsc |
| 5.3 x86 | clocksource=acpi_pm |
| 4.8 AMD64/Intel 64 | notsc |
| 4.8 x86 | clock=pmtmr |
| 3.9 AMD64/Intel 64 | Additional parameters are not required |
| 3.9 x86 | Additional parameters are not required |
