---
title: Measurements
authors: vfeenstr
wiki_title: Feature/VDSM VM Query API/Measurements
wiki_revision_count: 23
wiki_last_updated: 2014-07-14
---

# Measurements

## What was Measured

The measurements performed here have been using the body sizes of the data transmitted over the wire in response to the used vdsm API. This section of the document describes how the simulation of the engine was performed and which API calls have been measured.

All tests performed here are simulating a time frame of 15 minutes.

### Current

Current represents how we are currently polling VDSM for the data of Virtual Machines. VDSM is polled every 3 seconds where there is called the 'list' API call and then every 5. time getAllVmStats is called. The list API call just sends the VM Ids and the status of the VM to the caller. 'getAllVmStats' contains various items, such as statistics, guest agent repoted data and various configuration and status fields.

The sequence currently looks like this:

1.  getAllVmStats
2.  list
3.  list
4.  list
5.  list
6.  getAllVmStats
7.  list
8.  ...

### New

This test is using the proposed queryVms API call.

The test has been performed by calling 300 times queryVms and remembering the 'queryStamp' return value and passing it as the 'changedSince' parameter value with the next call. The first call did not have the queryStamp value therefore the full data set has been returned. This was done to simulate properly and fairly simulate the first 15 minutes of the engine querying the hosts.

### New Status

### New Stats

### New Stats & Status

## Idle VMs

### 6 VMs

![](Vdsm-query-interface-measurements-6vms-idle.png "Vdsm-query-interface-measurements-6vms-idle.png")

| -                  | Total Body Size | Total Body Size in KiB | Total Savings % | avg. Body Size | avg Body Savings % |
|--------------------|-----------------|------------------------|-----------------|----------------|--------------------|
| current            | 3336905         | 3.18                   | 0               | 11123.02       | 0                  |
| new                | 761709          | 0.73                   | 77.17           | 2539.03        | 77.17              |
| new status         | 640127          | 0.61                   | 80.82           | 2133.76        | 80.82              |
| new stats          | 778709          | 0.74                   | 76.66           | 2472.09        | 77.77              |
| new stats & status | 657336          | 0.63                   | 80.30           | 2086.78        | 81.24              |

### 100 VMs

![](Vdsm-query-interface-measurements-100vms-idle.png "Vdsm-query-interface-measurements-100vms-idle.png")

| -                  | Total Body Size | Total Body Size in KiB | Total Savings % | avg. Body Size | avg Body Savings % |
|--------------------|-----------------|------------------------|-----------------|----------------|--------------------|
| current            | 51975066        | 49.57                  | 0.00            | 173250.22      | 0.00               |
| new                | 13052561        | 12.45                  | 74.89           | 43508.54       | 74.89              |
| new status         | 8922576         | 8.51                   | 82.83           | 29741.92       | 82.83              |
| new stats          | 13162705        | 12.55                  | 74.67           | 41786.37       | 75.88              |
| new stats & status | 9143265         | 8.72                   | 82.41           | 29026.24       | 83.25              |

### 1000 VMs

![](Vdsm-query-interface-measurements-1000vms-idle.png "Vdsm-query-interface-measurements-1000vms-idle.png")

| -                  | Total Body Size | Total Body Size in KiB | Total Savings % | avg. Body Size | avg Body Savings % |
|--------------------|-----------------|------------------------|-----------------|----------------|--------------------|
| current            | 516132691       | 492.22                 | 0.00            | 1720442.30     | 0.00               |
| new                | 204050147       | 194.60                 | 60.47           | 680167.16      | 60.47              |
| new status         | 122473350       | 116.80                 | 76.27           | 408244.50      | 76.27              |
| new stats          | 171220290       | 163.29                 | 66.83           | 543556.48      | 68.41              |
| new stats & status | 97051742        | 92.56                  | 81.20           | 308100.77      | 82.09              |

## Fake Stats

### 6 VMs

![](Vdsm-query-interface-measurements-6vms-fakestats.png "Vdsm-query-interface-measurements-6vms-fakestats.png")

| -                  | Total Body Size | Total Body Size in KiB | Total Savings % | avg. Body Size | avg Body Savings % |
|--------------------|-----------------|------------------------|-----------------|----------------|--------------------|
| current            | 3552611         | 3.3880338669           | 0.00            | 11842.04       | 0.00               |
| new                | 4362378         | 4.1602878571           | -22.79          | 14541.26       | -22.79             |
| new status         | 1331638         | 1.2699489594           | 62.52           | 4438.79        | 62.52              |
| new stats          | 1187632         | 1.1326141357           | 66.57           | 3770.26        | 68.16              |
| new status & stats | 824446          | 0.7862529755           | 76.79           | 2617.29        | 77.90              |

### 100 VMs

![](Vdsm-query-interface-measurements-100vms-fakestats.png "Vdsm-query-interface-measurements-100vms-fakestats.png")

| -                  | Total Body Size | Total Body Size in KiB | Total Savings % | avg. Body Size | avg Body Savings % |
|--------------------|-----------------|------------------------|-----------------|----------------|--------------------|
| current            | 57541078        | 54.8754482269          | 0.00            | 191803.59      | 0.00               |
| new                | 71417759        | 68.1092824936          | -24.12          | 238059.20      | -24.12             |
| new status         | 20186805        | 19.2516374588          | 64.92           | 67289.35       | 64.92              |
| new stats          | 17834759        | 17.0085515976          | 69.01           | 56618.28       | 70.48              |
| new status & stats | 11949463        | 11.3958959579          | 79.23           | 37934.80       | 80.22              |

### 1000 VMs

![](Vdsm-query-interface-measurements-1000vms-fakestats.png "Vdsm-query-interface-measurements-1000vms-fakestats.png")

| -                  | Total Body Size | Total Body Size in KiB | Total Savings % | avg. Body Size | avg Body Savings % |
|--------------------|-----------------|------------------------|-----------------|----------------|--------------------|
| current            | 571238141       | 544.7751436234         | 0.00            | 1904127.14     | 0.00               |
| new                | 725224600       | 691.628074646          | -26.96          | 2417415.33     | -26.96             |
| new status         | 200467582       | 191.1807842255         | 64.91           | 668225.27      | 64.91              |
| new stats          | 193966163       | 184.980547905          | 66.04           | 615765.60      | 67.66              |
| new status & stats | 118286166       | 112.8064785004         | 79.29           | 375511.64      | 80.28              |

## Windows VMs

### 6 VMs

![](Vdsm-query-interface-measurements-6vms-windows.png "Vdsm-query-interface-measurements-6vms-windows.png")

| -                  | Total Body Size | Total Body Size in KiB | Total Savings % | avg. Body Size | avg Body Savings % |
|--------------------|-----------------|------------------------|-----------------|----------------|--------------------|
| current            | 6266652         | 5.98                   | 0.00            | 20888.84       | 0.00               |
| new                | 791384          | 0.75                   | 87.37           | 2637.95        | 87.37              |
| new status         | 678418          | 0.65                   | 89.17           | 2261.39        | 89.17              |
| new stats          | 813910          | 0.78                   | 87.01           | 2583.84        | 87.63              |
| new stats & status | 697203          | 0.66                   | 88.87           | 2213.34        | 89.40              |

### 100 VMs

![](Vdsm-query-interface-measurements-100vms-windows.png "Vdsm-query-interface-measurements-100vms-windows.png")

| -                  | Total Body Size | Total Body Size in KiB | Total Savings % | avg. Body Size | avg Body Savings % |
|--------------------|-----------------|------------------------|-----------------|----------------|--------------------|
| current            | 107161980       | 102.20                 | 0.00            | 357206.60      | 0.00               |
| new                | 13733787        | 13.10                  | 87.18           | 45779.29       | 87.18              |
| new status         | 9710008         | 9.26                   | 90.94           | 32366.69       | 90.94              |
| new stats          | 13888555        | 13.25                  | 87.04           | 44090.65       | 87.66              |
| new stats & status | 9924124         | 9.46                   | 90.74           | 31505.16       | 91.18              |
