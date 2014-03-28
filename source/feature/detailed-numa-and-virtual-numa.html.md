---
title: Detailed NUMA and Virtual NUMA
authors: bruceshi, jasonliao
wiki_title: Features/Detailed NUMA and Virtual NUMA
wiki_revision_count: 56
wiki_last_updated: 2014-05-06
---

# NUMA and Virtual NUMA

### Summary

This feature allow Enterprise customers to provision large guests for their traditional scale-up enterprise workloads and expect low overhead due to visualization.

*   Query target host’s NUMA topology
*   NUMA bindings of guest resources (vCPUs & memory)
*   Virtual NUMA topology

You may also refer to the [simple feature page](http://www.ovirt.org/Features/NUMA_and_Virtual_NUMA).

### Owner

*   Name: [ Jason Liao](User:JasonLiao), [ Bruce Shi](User:BruceShi)
*   Email: <chuan.liao@hp.com>, <xiao-lei.shi@hp.com>
*   IRC: jasonliao, bruceshi @ #ovirt (irc.oftc.net)

### Current status

*   Target Release: oVirt 3.5
*   Status: design
*   Last updated: 25 Mar 2014

This is the detailed design page for NUMA and Virtual NUMA

### Data flow diagram

![](Data_Flow_Diagram.png "Data_Flow_Diagram.png")

### Interface & data structure

#### Interface between VDSM and libvirt

1.  I-1.1 Host's NUMA node index and CPU id of each NUMA node
2.  I-1.2 Host's NUMA node memory information, include total and free memory
3.  I-1.5 Configuration of VM's memory allocation mode and memory comes from which NUMA nodes
4.  I-1.6 Configuration of VM's virtual NUMA topology

*   I-1.1 Seek the host NUMA nodes information by using `getCapabilities` API in libvirt

<!-- -->

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

*   I-1.2 Seek the host NUMA nodes memory information by using `getMemoryStats` API in libvirt, the below is the data format of API returned value

<!-- -->

    { total: int, free: int }

*   I-1.5 Create a new function `appendNumaTune` in VDSM vm module to write the VM numatune configuration into libvirt domain xml follow the below format

<!-- -->

    <domain>
        ...
        <numatune>
            <memory mode='interleave' nodeset='0-1'/>
        </numatune>
        …
    </domain>

*   I-1.6 Modify function `appendCpu` in VDSM vm module to write the VM virtual NUMA topology configuration into libvirt domain xml follow the below format

<!-- -->

    <cpu>
        ...
        <numa>
          <cell cpus='0-7' memory='10485760'/>
          <cell cpus='8-15' memory='10485760'/>
        </numa>
        ...
    </cpu>

#### Interface between VDSM and Host

1.  I-1.3 Statistics data of each host CPU core which include %usr (%usr+%nice), %sys and %idle.
2.  I-1.4 Data structure to be provided to MOM component
3.  I-1.7 NUMA distances capture from command
4.  I-1.8 Automatic NUMA balancing on host

*   I-1.3 Sampling host CPU statistics data in `/proc/stat`, the whole data format is showing as below. We will use column 1 to 5 which include user, system, nice and idle CPU handlers to calculate CPU statistics data in engine side

<!-- -->

    $ cat /proc/stat
    cpu  268492078 16093 132943706 6545294629 19023496 898 138160 0 57789592
    cpu0 62042038 3012 52198814 1638619972 2438624 4 12068 0 16721375
    cpu1 62779520 2733 25830756 1647361083 6001324 1 34617 0 16341547
    cpu2 77892630 5788 32963856 1610093241 8367287 889 80447 0 8205583
    cpu3 65777888 4559 21950279 1649220333 2216260 4 11027 0 16521086

*   I-1.4 Data structure that provided to MOM component

To be continue...

*   I-1.7 libivirt API do not support to get NUMA distances information, so we use command `numactl` to get the distances information

<!-- -->

    $ numactl -H
    node distances:
    node   0   1 
      0:  10  20 
      1:  20  10

*   I-1.8 In kernels who having Automatic NUMA balancing feature, use command `sysctl -a |grep numa_balancing` to check the Automatic NUMA balancing value is turn on or off

<!-- -->

    $ sysctl -a | grep numa_balancing
    kernel.numa_balancing = 1

#### Interface between VDSM and engine core

1.  I-2.1 Report host support automatic NUMA balancing situation, NUMA node distances, NUMA nodes information, include NUMA node index, cpu ids and total memory, from VDSM to engine core
2.  I-2.2 Report host NUMA nodes memory information (free memory and used memory percentage) and each cpu statistics (system, idle, user cpu percentage) from VDSM to engine core
3.  I-2.3 Configuration of set VM's numatune and virtual NUMA topology from engine core to VDSM

*   I-2.1 Transfer data format of host NUMA nodes information

<!-- -->

    'autoNumaBalancing': true/false
    'numaDistances': 'str'
    'numaNodes': {'<nodeIndex>': {'cpus': [int], 'totalMemory': 'str'}, …}

*   I-2.2 Transfer data format of host CPU statistics and NUMA nodes memory information

<!-- -->

    'numaNodeMemFree': {'<nodeIndex>': {'memFree': 'str', 'memPercent': int}, …}
    'cpuStatistics': {'<cpuId>': {'numaNodeIndex': int, 'cpuSys': 'str', 'cpuIdle': 'str', 'cpuUser': 'str'}, …}

*   I-2.3 Transfer data format of set VM numatune and virtual NUMA topology

<!-- -->

    'numaTune': {'mode': 'str', 'nodeset': 'str'}
    'guestNumaNodes': [{'cpus': 'str', 'memory': 'str'}, …]

#### Interface between engine core and database (schema)

1.  I-3.1 Schema modification of `vds_dynamic` table to include host's NUMA node distance information, NUMA node count and automatic NUMA balancing support flag.
2.  I-3.2 Add table `vds_cpu_statistics` to include host cpu statistics information (system, user, idle cpu time and used cpu percentage)
3.  I-3.3 Add table `vds_numa_node_statistics` to include host NUMA node statistics information (system, user, idle cpu time, used cpu percentage, free memory and used memory percentage)
4.  I-3.4 Schema modification of `vm_static` table to include NUMA type, numatune mode configuration and virtual NUMA node count
5.  I-3.5 Add table `vds_numa_node` to include host NUMA node information (node index, total memory, cpu count of each node, cpu list of each node)
6.  I-3.6 Add table `vm_numa_node` to include vm virtual NUMA node information (node index, total memory, vCPU count of each node, vCPU list of each node)
7.  I-3.7 Add table `vm_numatune_nodeset` to include vm numatune nodeset configuration (this is a relationship table, store the map relations between vm and `vds_numa_node`)
8.  I-3.8 Add table `vm_vds_numa_node_map` to include the configuration of vm virtual NUMA nodes pinning to host NUMA nodes (this is a relationship table, store the map relations between `vm_numa_node` and `vds_numa_node`)

The above interfaces are defined with database design diagram ![](Database_design_diagram.png "fig:Database_design_diagram.png")

*   Related database scripts change:
    1.  Add `numa_sp.sql` to include the store procedures which handle the operations in table `vm_numa_node`, `vds_numa_node`, `vm_numatune_nodeset` and `vds_numa_node_statistics`. It will provide the store procedures to insert, update and delete data and kinds of query functions.
    2.  Modify `vds_sp.sql` to add some store procedures which handle the operations in table `vds_cpu_statistics`, including insert, update, delete and kinds of query functions.
    3.  Modify the function of `InsertVdsDynamic`, `UpdateVdsDynamic` in `vds_sp.sql` to add new columns `auto_numa_banlancing`, `numa_node_distance_list` and `vds_numa_node_count`.
    4.  Modify the function of `InsertVmStatic`, `UpdateVmStatic` in `vms_sp.sql` to add three new columns `numa_manual_binding`, `numatune_mode` and `vm_numa_node_count`.
    5.  Modify `create_views.sql` to add new columns `numa_manual_binding`, `numatune_mode` and `vm_numa_node_count` in view `vms`; add new columns `auto_numa_banlancing`, `numa_node_distance_list` and `vds_numa_node_count` in view `vds`.
    6.  Modify `create_views.sql` to add new views, including view `vds_numa_node_view` which joins `vds_static`, `vds_numa_node` and `vds_numa_node_statistics`; view `vm_numa_node_view` which joins `vm_static`, `vm_numa_node`; view `vm_numatune_nodeset_view` which joins `vm_static`, `vm_numatune_nodeset` and `vds_numa_node`.
    7.  Modify `upgrade/post_upgrade/0010_add_object_column_white_list_table.sql` to add new columns `auto_numa_banlancing`, `numa_node_distance_list` and `vds_numa_node_count`.
    8.  Add one script under `upgrade/` to create tables - `vm_numa_node`, `vds_numa_node`, `vm_numatune_nodeset`, `vds_numa_node_statistics` and `vds_cpu_statistics` and add columns in table `vds_dynamic` and `vm_static`.
    9.  Create the following indexes in the script mentioned in point 8:
        -   Index on column `vm_guid` of table `vm_numa_node`
        -   Index on column `vds_numa_node_count` of table `vds_dynamic`
        -   Indexes on each of the columns `vm_guid` and `vds_numa_node_id` of table `vm_numatune_nodeset`
        -   Indexes on each of the columns `vds_id` and `cpu_count` of table `vds_numa_node`
        -   Indexes on each of the columns `vds_id` and `vds_numa_node_id` of table `vds_cpu_statistics`

    10. Modify `create_views.sql` to add new columns `auto_numa_balancing` and `numa_node_distance_list` in view `vds_with_tags`.

<!-- -->

*   Related DAO change:
    1.  Add `VdsNumaNodeDAO` and related implemention to provide data save, update, delete and kinds of queries in table `vds_numa_node` and `vds_numa_node_statistics`. Add `VdsNumaNodeDAOTest` for `VdsNumaNodeDAO` meanwhile.
    2.  Add `VmNumaNodeDAO` and related implemention to provide data save, update, delete and kinds of queries in table `vm_numa_node`. Add `VmNumaNodeDAOTest` for `VmNumaNodeDAO` meanwhile.
    3.  Add `VmNumatuneNodesetDAO` and related implemention to provide data save, update, delete in table `vm_numatune_nodeset` and queries to get vm configured VDS NUMA node which needs to join table `vm_static`,` vm_numatune_nodeset` and `vds_numa_node`. Add `VmNumatuneNodesetDAOTest` for `VmNumatuneNodesetDAO` meanwhile.
    4.  Add `VdsCpuStatisticsDao` and related implementation to provide data save, update, delete and kinds of queries in table `vds_cpu_statistics`. Add `VdsCpuStatisticsDAOTest` for `VdsCpuStatisticsDAO` meanwhile.
    5.  Modify `VdsDynamicDAODbFacadeImpl` and `VdsDAODbFacadeImpl` to add the map of new columns `auto_numa_banlancing`, `numa_node_distance_list` and `vds_numa_node_count`. Run `VdsDynamicDAOTest` to verify the modification.
    6.  Modify `VmStaticDAODbFacadeImpl` and `VmDAODbFacadeImpl` to add the map of new columns `numa_type`, `numatune_mode` and `numa_node_count`. Run `VmStaticDAOTest` to verify the modification.

<!-- -->

*   Related search engine change

Currently, we plan to provide below search functions about NUMA feature, each field support the numeric relation of “>”, “<”, “>=”, “<=”, “=”, “!=”.

1.  Search hosts with the below NUMA related fields:
    -   NUMA node number
    -   NUMA node cpu count
    -   NUMA node total memory
    -   NUMA node memory usage
    -   NUMA node cpu usage

2.  Search vms with the below NUMA related fields:
    -   Manual NUMA binding
    -   NUMA tune mode
    -   Virtual NUMA node number
    -   Virtual NUMA node vcpu count
    -   Virtual NUMA node total memory

3.  Manual NUMA binding and NUMA tune mode support enum value relation, the others support the numeric relation.
    -   Modify `org.ovirt.engine.core.searchbackend.SearchObjects` to add new entry NUMANODES and VIRTUALNUMANODES.
    -   Add `org.ovirt.engine.core.searchbackend.NumaNodeConditionFieldAutoCompleter` to provide NUMA node related filters auto completion;
    -   Add `org.ovirt.engine.core.searchbackend.VirtualNumaNodeConditionFieldAutoCompleter` to provide virtual NUMA node related filters auto completion.
    -   Modify `org.ovirt.engine.core.searchbackend.SearchObjectAutoCompleter` to add new joins, one is HOST joins NUMANODES on vds_id, the other is VM joins VIRTUALNUMANODES on vm_guid.
    -   Add new entries in entitySearchInfo accordingly. NUMANODES will use new added view vds_numa_node_view and VIRTUALNUMANODES will use new added view vm_numa_node_view.
    -   Modify `org.ovirt.engine.core.searchbackend.VdsCrossRefAutoCompleter` to add auto complete entry NUMANODES; Modify `org.ovirt.engine.core.searchbackend.VmCrossRefAutoCompleter` to add auto complete entry VIRTUALNUMANODES.

#### Interface and data structure in engine side

The below interfaces are defined with class diagram to easier understand the data relationship

*   The information and setup of VM is defined in entity VM of engine core as below, the data interface in I-4.1, I-5.1 and I-6.1 will use these data

1.  I-4.1 Provide vm NUMA configuration properties to scheduler (numaType, guestNumaNodeList)
2.  I-5.1 Provide vm NUMA configuration properties which is binding to UI model (numaType, numaTuneMode, numaTuneNodeList, guestNumaNodeList)
3.  I-6.1 Provide vm NUMA configuration properties which is showing vm NUMA information in restful API

The above interfaces are defined with class diagram ![](Vm_class_diagram.png "fig:Vm_class_diagram.png")

*   The information and setup of host is defined in entity VDS of engine core as below, the data interface in I-4.2, I-5.2, I-5.3 and I-6.2 will use these data

1.  I-4.2 Provide host NUMA statistics information to scheduler, include free memory and used memory percentage of each NUMA node, total used cpu percentage of each NUMA node
2.  I-5.2 Provide host NUMA node index list when create vm
3.  I-5.3 Provide host NUMA statistics information, include free/total memory and used memory percentage, user/system/idle cpu percentage and total used cpu percentage
4.  I-6.2 Provide host NUMA information which are mentioned above (host NUMA node and statistics information) in restful API

The above interfaces are defined with class diagram ![](Vds_class_diagram.png "fig:Vds_class_diagram.png")
