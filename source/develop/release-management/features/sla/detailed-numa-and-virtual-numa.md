---
title: Detailed NUMA and Virtual NUMA
authors:
  - bruceshi
  - jasonliao
---

# NUMA and Virtual NUMA

## Summary

This feature allow Enterprise customers to provision large guests for their traditional scale-up enterprise workloads and expect low overhead due to visualization.

*   Query target host’s NUMA topology
*   NUMA bindings of guest resources (vCPUs & memory)
*   Virtual NUMA topology

You may also refer to the [simple feature page](/develop/release-management/features/sla/numa-and-virtual-numa.html).

## Owner

*   Name: Jason Liao (JasonLiao), Bruce Shi (BruceShi)
*   Email: <chuan.liao@hp.com>, <xiao-lei.shi@hp.com>
*   IRC: jasonliao, bruceshi @ #ovirt (irc.oftc.net)

## Current status

*   Target Release: oVirt 3.5
*   Status: design
*   Last updated: 25 Mar 2014

This is the detailed design page for NUMA and Virtual NUMA

## Data flow diagram

![](/images/wiki/Data_Flow_Diagram.png)

## Interface & data structure

### Interface between VDSM and libvirt

1.  I-1.1 Host's NUMA node index and CPU id of each NUMA node
2.  I-1.2 Host's NUMA node memory information, include total and free memory
3.  I-1.5 Configuration of VM's memory allocation mode and memory comes from which NUMA nodes
4.  I-1.6 Configuration of VM's virtual NUMA topology

*   I-1.1 Seek the host NUMA nodes information by using `getCapabilities` API in libvirt
    ```xml

    <capabilities>
        …
        <host>
            ...
            <topology>
                <cells num='1'>
                    <cell id='0'>
                        <cpus num='2'>
                            <cpu id='0'/>
                            <cpu id='1'/>
                        </cpus>
                    </cell>
          </cells>
            </topology>
            …
        </host>
        …
    </capabilities>
    ```
*   I-1.2 Seek the host NUMA nodes memory information by using `getMemoryStats` API in libvirt, the below is the data format of API returned value
    ```json
    { total: int, free: int }
    ```

*   I-1.5 Create a new function `appendNumaTune` in VDSM vm module to write the VM numatune configuration into libvirt domain xml follow the below format
    ```xml
    <domain>
        ...
        <numatune>
            <memory mode='interleave' nodeset='0-1'/>
        </numatune>
        …
    </domain>
    ```

*   I-1.6 Modify function `appendCpu` in VDSM vm module to write the VM virtual NUMA topology configuration into libvirt domain xml follow the below format
    ```xml
    <cpu>
        ...
        <numa>
          <cell cpus='0-7' memory='10485760'/>
          <cell cpus='8-15' memory='10485760'/>
        </numa>
        ...
    </cpu>
    ```

### Interface between VDSM and Host

1.  I-1.3 Statistics data of each host CPU core which include %usr (%usr+%nice), %sys and %idle.
2.  I-1.4 Data structure to be provided to MOM component
3.  I-1.7 NUMA distances capture from command
4.  I-1.8 Automatic NUMA balancing on host

*   I-1.3 Sampling host CPU statistics data in `/proc/stat`, the whole data format is showing as below. We will use column 1 to 5 which include user,
    system, nice and idle CPU handlers to calculate CPU statistics data in engine side
    ```console
    $ cat /proc/stat
    cpu  268492078 16093 132943706 6545294629 19023496 898 138160 0 57789592
    cpu0 62042038 3012 52198814 1638619972 2438624 4 12068 0 16721375
    cpu1 62779520 2733 25830756 1647361083 6001324 1 34617 0 16341547
    cpu2 77892630 5788 32963856 1610093241 8367287 889 80447 0 8205583
    cpu3 65777888 4559 21950279 1649220333 2216260 4 11027 0 16521086
    ```

*   I-1.4 Data structure that provided to MOM component

MOM use the VDSM HypervisorInterface using `API.py` `Global.getCapabilities` function to get host NUMA topology data
```python
    'autoNumaBalancing': int
    'numaNodeDistance': {'<nodeIndex>': [int], ...}
    'numaNodes': {'<nodeIndex>': {'cpus': [int], 'totalMemory': 'str'}, …}
```

using `API.py` `Global.getStats` function to get host NUMA statistics data
```python
    'numaNodeMemFree': {'<nodeIndex>': {'memFree': 'str', 'memPercent': int}, …}
    'cpuStatistics': {'<cpuId>': {'nodeIndex': int, 'cpuSys': 'str', 'cpuIdle': 'str', 'cpuUser': 'str'}, …}
```

*   I-1.7 libivirt API do not support to get NUMA distances information, so we use command `numactl` to get the distances information
    ```console
    $ numactl -H
    node distances:
    node   0   1
      0:  10  20
      1:  20  10
    ```
*   I-1.8 In kernels who having Automatic NUMA balancing feature, use command `sysctl -a |grep numa_balancing` to check the Automatic NUMA balancing value is turn on or off
    ```console
    $ sysctl -a | grep numa_balancing
    kernel.numa_balancing = 1
    ```

### Interface between VDSM and engine core

1.  I-2.1 Report host support automatic NUMA balancing situation, NUMA node distances, NUMA nodes information, include NUMA node index, cpu ids and total memory, from VDSM to engine core
2.  I-2.2 Report host NUMA nodes memory information (free memory and used memory percentage) and each cpu statistics (system, idle, user cpu percentage) from VDSM to engine core
3.  I-2.3 Configuration of set VM's numatune and virtual NUMA topology from engine core to VDSM

*   I-2.1 Transfer data format of host NUMA nodes information
    ```python
    'autoNumaBalancing': int
    'numaDistances': {'<nodeIndex>': [int], ...}
    'numaNodes': {'<nodeIndex>': {'cpus': [int], 'totalMemory': 'str'}, …}
    ```

*   I-2.2 Transfer data format of host CPU statistics and NUMA nodes memory information
    ```python
    'numaNodeMemFree': {'<nodeIndex>': {'memFree': 'str', 'memPercent': int}, …}
    'cpuStatistics': {'<cpuId>': {'numaNodeIndex': int, 'cpuSys': 'str', 'cpuIdle': 'str', 'cpuUser': 'str'}, …}
    ```

*   I-2.3 Transfer data format of set VM numatune and virtual NUMA topology
    ```python
    'numaTune': {'mode': 'str', 'nodeset': 'str'}
    'guestNumaNodes': [{'cpus': 'str', 'memory': 'str'}, …]
    ```

### Interface between engine core and database (schema)

1.  I-3.1 Schema modification of `vds_dynamic` table to include host's NUMA node count and automatic NUMA balancing status.
2.  I-3.2 Add table `vds_cpu_statistics` to include host cpu statistics information (system, user, idle cpu time and used cpu percentage).
3.  I-3.3 Schema modification of `vm_static` table to include numatune mode configuration and virtual NUMA node count.
4.  I-3.4 Add table `numa_node` to include host/vm NUMA node information (node index, total memory, cpu count of each node)
    and statistics information (system, user, idle cpu time, used cpu percentage, free memory and used memory percentage).
5.  I-3.5 Add table `vm_vds_numa_node_map` to include the configuration of vm virtual NUMA nodes pinning to host NUMA nodes
   (this is a nested relationship table, store the map relations between vm NUMA nodes and host NUMA nodes which are all in table numa_node).
6.  I-3.6 Add table `numa_node_cpu_map` to include the cpu information that each host/vm NUMA node contains.
7.  I-3.7 Add table `numa_node_distance` to include the distance information between the NUMA nodes.

The above interfaces are defined with database design diagram ![](/images/wiki/Database_design_diagram.png)

*   Related database scripts change:
    1.  Add `numa_sp.sql` to include the store procedures which handle the operations in
        table `numa_node`, `numa_node_cpu_map`, `vm_vds_numa_node_map` and `numa_node_distance`. It will provide the store procedures to insert, update and delete data and kinds of query functions.
    2.  Modify `vds_sp.sql` to add some store procedures which handle the operations in table `vds_cpu_statistics`, including insert, update, delete and kinds of query functions.
    3.  Modify the function of `InsertVdsDynamic`, `UpdateVdsDynamic` in `vds_sp.sql` to add new columns `auto_numa_banlancing` and `vds_numa_node_count`.
    4.  Modify the function of `InsertVmStatic`, `UpdateVmStatic` in `vms_sp.sql` to add two new columns `numatune_mode` and `vm_numa_node_count`.
    5.  Modify `create_views.sql` to add new columns `numatune_mode` and `vm_numa_node_count` in view `vms` and `vms_with_tags`;
        add new columns `auto_numa_banlancing` and `vds_numa_node_count` in view `vds` and `vds_with_tags`.
    6.  Modify `create_views.sql` to add new views, including view `vds_numa_node_view` which joins `vds_dynamic` and `numa_node`; view `vm_numa_node_view` which joins `vm_static` and `numa_node`.
    7.  Modify `upgrade/post_upgrade/0010_add_object_column_white_list_table.sql` to add new columns `auto_numa_banlancing` and `vds_numa_node_count`.
    8.  Add one script under `upgrade/` to create tables - `numa_node`, `vds_cpu_statistics`, `vm_vds_numa_node_map`, `numa_node_cpu_map`, `numa_node_distance`
        and add columns in table `vds_dynamic` and `vm_static`.
    9.  Create the following indexes:
        -   Index on column `vm_or_vds_guid` of table `numa_node`
        -   Index on column `vds_id` of table `vds_cpu_statistics`
        -   Index on column `numa_node_id` of table `numa_node_cpu_map`
        -   Index on column `numa_node_id` of table `numa_node_distance`
        -   Indexes on each of the columns `vm_numa_node_id` and `vds_numa_node_id` of table `vm_vds_numa_node_map`

*   Related DAO change:
    1.  Add `NumaNodeDAO` and related implemention to provide data save, update, delete and kinds of queries in
        table `numa_node`, `numa_node_cpu_map`, `vm_vds_numa_node_map` and `numa_node_distance`. Add `NumaNodeDAOTest` for `NumaNodeDAO` meanwhile.
    2.  Add `VdsCpuStatisticsDao` and related implementation to provide data save, update, delete and kinds of queries
        in table `vds_cpu_statistics`. Add `VdsCpuStatisticsDAOTest` for `VdsCpuStatisticsDAO` meanwhile.
    3.  Modify `VdsDynamicDAODbFacadeImpl` and `VdsDAODbFacadeImpl` to add the map of new 
        columns `auto_numa_banlancing` and `vds_numa_node_count`. Run `VdsDynamicDAOTest` to verify the modification.
    4.  Modify `VmStaticDAODbFacadeImpl` and `VmDAODbFacadeImpl` to add the map of new columns `numatune_mode` and `numa_node_count`. Run `VmStaticDAOTest` to verify the modification.


*   Related search engine change

Currently, we plan to provide below search functions about NUMA feature, each field support the numeric relation of “>”, “<”, “>=”, “<=”, “=”, “!=”.

1.  Search hosts with the below NUMA related fields:
    -   NUMA node number
    -   NUMA node cpu count
    -   NUMA node total memory
    -   NUMA node memory usage
    -   NUMA node cpu usage

2.  Search vms with the below NUMA related fields:
    -   NUMA tune mode
    -   Virtual NUMA node number
    -   Virtual NUMA node vcpu count
    -   Virtual NUMA node total memory

NUMA tune mode support enum value relation, the others support the numeric relation.

We will do the following modifications:

1.  Modify `org.ovirt.engine.core.searchbackend.SearchObjects` to add new entry NUMANODES.
2.  Add `org.ovirt.engine.core.searchbackend.NumaNodeConditionFieldAutoCompleter` to provide NUMA node related filters auto completion;
3.  Modify `org.ovirt.engine.core.searchbackend.SearchObjectAutoCompleter` to add new joins, one is HOST joins NUMANODES on vds_id, the other is VM joins NUMANODES on vm_guid.
4.  Add new entries in entitySearchInfo accordingly. NUMANODES will use new added view vds_numa_node_view and view vm_numa_node_view.
5.  Modify `org.ovirt.engine.core.searchbackend.VdsCrossRefAutoCompleter` to add auto complete entry NUMANODES.

*   Cascade-delete
    1.  When user remove a virtual NUMA node, the related rows in table `numa_node_cpu_map`, `vm_vds_numa_node_map`, `numa_node_distance`
        (maybe in future, currently no distance information for virtual NUMA node) and `numa_node` should be removed meanwhile.
    2.  When user remove a vm, all the virtual NUMA nodes of this vm should be removed, follow above item to do the cascade-delete.
    3.  When user remove a host, the related rows in table `numa_node_cpu_map`, `vm_vds_numa_node_map`, `numa_node_distance`, `numa_node` and `vds_cpu_statistics` should be removed meanwhile.

### Interface and data structure in engine core

![](/images/wiki/ARCH_Class_Diagram.png)

*   Entities
    -   `VDS` has many `VdsNumaNode` objects in dynamic data (collect from vds capatibility)
    -   `VdsNumaNode` is core entity for host NUMA topology, it links one statistics object `VdsNumaNodeStatistics` which contains some real-time data (free memory, NUMA node cpu usage etc.)
    -   `VM` has many `VmNumaNode` object in dynamic data (configured by user)
    -   `VmNumaNode` is core entity for VM NUMA topology.
    -   `NumaTuneMode` is the memory tune mode (configured by user).
    -   `VdsNumaNode` has one-to-many relationship with `VmNumaNode`.
    -   `VdsNumaNode.cpuIds` links with `CpuStatistics.cpuId` to take a look inside NUMA node each CPU usage
*   Action & Query
    -   `GetVdsNumaNodeByVdsId, GetVmNumaNodeByVmId, GetVmNumaNodeByVdsNumaNodeId, GetCpuStatsByVdsId` use same parameters `IdQueryParameters`
    -   `AddVmNumaNode, UpdateVmNuamNode, RemoveVmNuamNode` use same parameters `VmNumaNodeParameters` to manage Virtual NUMA node in VM
    -   `SetNumaTuneMode` use parameters `NumaTuneModeParameters` to set the NUMA tuning mode for VM
    -   `GetVdsNumaNodeByVdsId` will return `List<VdsNumaNode>`
    -   `GetVmNumaNodeByVmId, GetVmNumaNodeByVdsNumaNodeId` will return `List<VmNumaNode>`
    -   `GetVmNumaNodeByVdsNumaNodeId` will query the `VmNumaNode`s under the `VdsNumaNode`
    -   `GetCpuStatsByVdsId` will return `List<CpuStatistics>`
    -   When `VmNumaNodeParameters.vdsNumaNodeId` is set to null, the `VmNumaNode` is unsigned.

### Interface and data structure in ovirt scheduler

Add NUMA filter and weight module to oVirt's scheduler, and add those to all cluster policies (inc. user defined).

*   NUMA Filter
    -   Fetches the (scheduled) VM virutal NUMA nodes.
    -   Fetches all virtual NUMA nodes topology ( CPU count, total memory ).
    -   Fetches all hosts NUMA nodes topology ( CPU count, total memory ).
    -   Remove all hosts that doesn't meet the matched NUMA nodes topology
        -   for positive, host NUMA node's CPU count > virtual NUMA node's CPU count
        -   for positive, host NUMA node's total memory > virtual NUMA node's total memory
*   NUMA Weight Module
    -   Fetches the (scheduled) VM virutal NUMA nodes.
    -   Fetches all virtual NUMA nodes topology ( CPU count, total memory, NUMA distance ).
    -   Fetches all hosts NUMA nodes topology and statistics ( CPU usage, free memory ).
    -   Score the hosts according to each NUMA nodes score
        -   for positive, in case a VM of the group is running on a certain host, give all other hosts a higher weight.
        -   for positive, give the host higher weight if the host NUMA node's CPU usage use up.
        -   for positive, give the host higher weight if the host NUMA node's memory use up.

Scheduler generate virtual NUMA topology To be continue ...

### Interface and data structure in restful API

host NUMA sub-collection

    /api/hosts/{host:id}/numanodes/

*   Supported actions - **GET** returns a list of host NUMA nodes. (using query GetVdsNumaNodeByVdsId)

host NUMA resource

    /api/hosts/{host:id}/numanodes/{numa:id}

*   Supported actions
    -   **GET** returns a specific NUMA node information: CPU list, total memory, map of distance with other nodes. (using VdsNumaNode properties)

host NUMA statistics

    /api/hosts/{host:id}/numanodes/{numa:id}/statistics

*   Supported actions
    -   **GET** returns a specific NUMA node statistics data: CPU usage, free memory. (using VdsNumaNode property NumaNodeStatistics)

vm virtual NUMA sub-collection

    /api/vms/{vm:id}/numanodes

*   Supported actions:
    -   **GET** returns a list of VM virtual NUMA nodes. (using query GetVmNumaNodeByVmId)
    -   **POST** attach a new virtual NUMA node on VM. (using action AddVmNumaNode)

vm virtual NUMA resource

    /api/vms/{vm:id}/numanodes/{vnuma:id}

*   Supported actions:
    -   **GET** returns a specific virtual NUMA node information, CPU list, total memory, pin to host NUMA nodes. (using VmNumaNode properties)
    -   **PUT* a virtual NUMA node configured on the VM. (using action UpdateVmNumaNode)
    -   **DELETE** removes a virtual NUMA node from the VM. (using action DeleteVmNumaNode)
