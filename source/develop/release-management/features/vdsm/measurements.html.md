---
title: Measurements
authors: vfeenstr
---

# Measurements

## Introdcution

### Motivation

The motivation for these tests, is to show how much more flexible the new API verb is but also to uncover potential \`gotchas\`. The section about the fake stats shows pretty good, that by not properly measuring the requested data. e.g. by blindly always requesting all changes, the usage of the API can cause more traffic on the wire than expected.

### What was Measured

The measurements performed here have been using the body sizes of the data transmitted over the wire in response to the used vdsm API. This section of the document describes how the simulation of the engine was performed and which API calls have been measured.

**All tests performed here are simulating a time frame of 15 minutes.**

### Description

#### list/getAllVMStats

Current represents how we are currently polling VDSM for the data of Virtual Machines. VDSM is polled every 3 seconds where there is called the 'list' API call and then every 5. time getAllVMStats is called. The list API call just sends the VM Ids and the status of the VM to the caller. 'getAllVMStats' contains various items, such as statistics, guest agent repoted data and various configuration and status fields.

The sequence currently looks like this:

1.  getAllVMStats
2.  list
3.  list
4.  list
5.  list
6.  getAllVMStats
7.  list
8.  ...

#### queryVms

This test is using the proposed queryVms API call.

The test has been performed by calling 300 times queryVms and remembering the 'queryStamp' return value and passing it as the 'changedSince' parameter value with the next call. The first call did not have the queryStamp value therefore the full data set has been returned. This was done to simulate properly and fairly simulate the first 15 minutes of the engine querying the hosts.

#### queryVms 4 status/1 all

This test is using the proposed queryVms API call.

This test has been implemented to simulate the current way of querying VDSM on top of the new proposed API.

1.  queryVms(changedSince=lastChanged)
2.  queryVms(fields='status', changedSince=lastChanged)
3.  queryVms(fields='status', changedSince=lastChanged)
4.  queryVms(fields='status', changedSince=lastChanged)
5.  queryVms(fields='status', changedSince=lastChanged)
6.  queryVms(changedSince=lastChanged)
7.  queryVms(fields='status', changedSince=lastChanged)
8.  ...

#### queryVms statistics every minute

This test is using the new proposed queryVms API call

This test assumes that certain statistics are only required every so often and for the sake of this test, the retrieval of the information has been scheduled to request this data statistics data every minute.

For this test the following fields have been categorized as statistics fields and are further refered to as \`statsFields\`

*   disksUsage
*   network
*   disks
*   memoryStats
*   memUsage

Illustrative querying sequence:

*   1. queryVms(exclude=statsFields, changedSince=lastChanged)
     queryVms(fields=statsFields, changedSince=statsLastChanged)
*   2. queryVms(exclude=statsFields, changedSince=lastChanged)
*   3. queryVms(exclude=statsFields, changedSince=lastChanged)
*   4. ...
*   20. queryVms(exclude=statsFields, changedSince=lastChanged)
*   21. queryVms(exclude=statsFields, changedSince=lastChanged)
     queryVms(fields=statsFields, changedSince=statsLastChanged)
*   22. queryVms(exclude=statsFields, changedSince=lastChanged)
*   23. ...

#### queryVms statistics & status

This test is using the new proposed queryVms API call

This test has been implemented as a combination out of tests performed by \`queryVms statistics every minute\` and \`queryVms 4 status/1 all\`.

Illustrative querying sequence:

*   1. queryVms(exclude=statsFields, changedSince=lastChanged)
     queryVms(fields=statsFields, changedSince=statsLastChanged)
*   2. queryVms(fields='status', changedSince=lastChanged)
*   3. queryVms(fields='status', changedSince=lastChanged)
*   4. queryVms(fields='status', changedSince=lastChanged)
*   5. queryVms(fields='status', changedSince=lastChanged)
*   6. queryVms(exclude=statsFields, changedSince=lastChanged)
*   7. ...
*   20. queryVms(fields='status', changedSince=lastChanged)
*   21. queryVms(exclude=statsFields, changedSince=lastChanged)
     queryVms(fields=statsFields, changedSince=statsLastChanged)
*   22. queryVms(fields='status', changedSince=lastChanged)
*   23. ...

**Note:** *The test here might have been optimized to NOT use separate calls when querying for the statistics since it overlaps with the general query, however for the sake of simplicity and potential difference on the engine side for the implementation this has been left this way.*

## Results

### Idle VMs

A set of mixed (Windows/Linux) vms having no active users or any kind of services running. A third (33%) having of those VMs have guest agents.

#### 6 VMs

![](/images/wiki/Vdsm-query-interface-measurements-6vms-idle.png)

| -                                | Total Body Size | Total Body Size in MiB | Total Savings % | avg. Body Size | avg Body Savings % |
|----------------------------------|-----------------|------------------------|-----------------|----------------|--------------------|
| queryVms statistics & status     | 657336          | 0.63                   | 80.30           | 2086.78        | 81.24              |
| queryVms statistics every minute | 778709          | 0.74                   | 76.66           | 2472.09        | 77.77              |
| queryVms 4 status/1 all          | 640127          | 0.61                   | 80.82           | 2133.76        | 80.82              |
| queryVms                         | 761709          | 0.73                   | 77.17           | 2539.03        | 77.17              |
| list/getAllVMStats               | 3336905         | 3.18                   | 0               | 11123.02       | 0                  |

#### 100 VMs

![](/images/wiki/Vdsm-query-interface-measurements-100vms-idle.png)

| -                                | Total Body Size | Total Body Size in MiB | Total Savings % | avg. Body Size | avg Body Savings % |
|----------------------------------|-----------------|------------------------|-----------------|----------------|--------------------|
| queryVms statistics & status     | 9143265         | 8.72                   | 82.41           | 29026.24       | 83.25              |
| queryVms statistics every minute | 13162705        | 12.55                  | 74.67           | 41786.37       | 75.88              |
| queryVms 4 status/1 all          | 8922576         | 8.51                   | 82.83           | 29741.92       | 82.83              |
| queryVms                         | 13052561        | 12.45                  | 74.89           | 43508.54       | 74.89              |
| list/getAllVMStats               | 51975066        | 49.57                  | 0.00            | 173250.22      | 0.00               |

#### 1000 VMs

![](/images/wiki/Vdsm-query-interface-measurements-1000vms-idle.png)

| -                                | Total Body Size | Total Body Size in MiB | Total Savings % | avg. Body Size | avg Body Savings % |
|----------------------------------|-----------------|------------------------|-----------------|----------------|--------------------|
| queryVms statistics & status     | 97051742        | 92.56                  | 81.20           | 308100.77      | 82.09              |
| queryVms statistics every minute | 171220290       | 163.29                 | 66.83           | 543556.48      | 68.41              |
| queryVms 4 status/1 all          | 122473350       | 116.80                 | 76.27           | 408244.50      | 76.27              |
| queryVms                         | 204050147       | 194.60                 | 60.47           | 680167.16      | 60.47              |
| list/getAllVMStats               | 516132691       | 492.22                 | 0.00            | 1720442.30     | 0.00               |

### Fake Stats

A set of VMs where the statistics for 'disksUsage', 'memUsage', 'cpuSys', 'cpuUser', 'network' have been actively manipulated to be different on every request. (Basically what the fake vm stats hook does just made suitable for this test)

This test simulates heavy workload VMs.

#### 6 VMs

![](/images/wiki/Vdsm-query-interface-measurements-6vms-fakestats.png)

| -                                | Total Body Size | Total Body Size in MiB | Total Savings % | avg. Body Size | avg Body Savings % |
|----------------------------------|-----------------|------------------------|-----------------|----------------|--------------------|
| new status & stats               | 824446          | 0.7862529755           | 76.79           | 2617.29        | 77.90              |
| queryVms statistics every minute | 1187632         | 1.1326141357           | 66.57           | 3770.26        | 68.16              |
| queryVms 4 status/1 all          | 1331638         | 1.2699489594           | 62.52           | 4438.79        | 62.52              |
| queryVms                         | 4362378         | 4.1602878571           | -22.79          | 14541.26       | -22.79             |
| list/getAllVMStats               | 3552611         | 3.3880338669           | 0.00            | 11842.04       | 0.00               |

#### 100 VMs

![](/images/wiki/Vdsm-query-interface-measurements-100vms-fakestats.png)

| -                                | Total Body Size | Total Body Size in MiB | Total Savings % | avg. Body Size | avg Body Savings % |
|----------------------------------|-----------------|------------------------|-----------------|----------------|--------------------|
| new status & stats               | 11949463        | 11.3958959579          | 79.23           | 37934.80       | 80.22              |
| queryVms statistics every minute | 17834759        | 17.0085515976          | 69.01           | 56618.28       | 70.48              |
| queryVms 4 status/1 all          | 20186805        | 19.2516374588          | 64.92           | 67289.35       | 64.92              |
| queryVms                         | 71417759        | 68.1092824936          | -24.12          | 238059.20      | -24.12             |
| list/getAllVMStats               | 57541078        | 54.8754482269          | 0.00            | 191803.59      | 0.00               |

#### 1000 VMs

![](/images/wiki/Vdsm-query-interface-measurements-1000vms-fakestats.png)

| -                                | Total Body Size | Total Body Size in MiB | Total Savings % | avg. Body Size | avg Body Savings % |
|----------------------------------|-----------------|------------------------|-----------------|----------------|--------------------|
| new status & stats               | 118286166       | 112.8064785004         | 79.29           | 375511.64      | 80.28              |
| queryVms statistics every minute | 193966163       | 184.980547905          | 66.04           | 615765.60      | 67.66              |
| queryVms 4 status/1 all          | 200467582       | 191.1807842255         | 64.91           | 668225.27      | 64.91              |
| queryVms                         | 725224600       | 691.628074646          | -26.96          | 2417415.33     | -26.96             |
| list/getAllVMStats               | 571238141       | 544.7751436234         | 0.00            | 1904127.14     | 0.00               |

### Windows VMs

Since the Windows virtual machines are producing more data reported by the guest agent due to the definition of the application list, as another sub test this simulates a fleet of Windows clones. Those Virtual Machines can be considered as a VM pool with 6 or 100 VMs. The VMs in this test have not been actively used, however actively reported their status and their the application list.

Please note that this is a test which is in comparison with the idle test, where 'list/getAllVmStats' would produce twice as much (even possibly even more data depending on what is installed on the windows machine) opposed to the current implementation of the application lists on Linux machines.

Just to give an idea about how significant this difference can be here a comparison of the query results: ![](/images/wiki/Vdsm-query-interface-measurements-100vms-mixed-vs-windows.png)

#### 6 VMs

![](/images/wiki/Vdsm-query-interface-measurements-6vms-windows.png)

| -                                | Total Body Size | Total Body Size in MiB | Total Savings % | avg. Body Size | avg Body Savings % |
|----------------------------------|-----------------|------------------------|-----------------|----------------|--------------------|
| queryVms statistics & status     | 697203          | 0.66                   | 88.87           | 2213.34        | 89.40              |
| queryVms statistics every minute | 813910          | 0.78                   | 87.01           | 2583.84        | 87.63              |
| queryVms 4 status/1 all          | 678418          | 0.65                   | 89.17           | 2261.39        | 89.17              |
| queryVms                         | 791384          | 0.75                   | 87.37           | 2637.95        | 87.37              |
| list/getAllVMStats               | 6266652         | 5.98                   | 0.00            | 20888.84       | 0.00               |

#### 100 VMs

![](/images/wiki/Vdsm-query-interface-measurements-100vms-windows.png)

| -                                | Total Body Size | Total Body Size in MiB | Total Savings % | avg. Body Size | avg Body Savings % |
|----------------------------------|-----------------|------------------------|-----------------|----------------|--------------------|
| queryVms statistics & status     | 9924124         | 9.46                   | 90.74           | 31505.16       | 91.18              |
| queryVms statistics every minute | 13888555        | 13.25                  | 87.04           | 44090.65       | 87.66              |
| queryVms 4 status/1 all          | 9710008         | 9.26                   | 90.94           | 32366.69       | 90.94              |
| queryVms                         | 13733787        | 13.10                  | 87.18           | 45779.29       | 87.18              |
| list/getAllVMStats               | 107161980       | 102.20                 | 0.00            | 357206.60      | 0.00               |
