---
title: Migration Enhancements
category: feature
authors:
  - mpolednik
  - mskrivan
  - ofrenkel
  - sandrobonazzola
  - tjelinek
---

# Migration Enhancements

## Summary

There are several problems with current migrations:

1.  All the policies are in VDSM, are simple, not tunable and always global (e.g. not possible to have different policies per different VMs)
2.  There is no way to configure the max incoming migrations; the max outgoing migrations and max bandwidth are set on VDSM side only
3.  There is no prevention of network overload in case the same network is shared for migration and other traffic (VM, display, storage, management)
4.  Guest is not able to do any preparation for the migration

The proposed solution to enhance issue #1 is to remove all the policies handling migrations from VDSM and move them to oVirt engine.
Engine will then expose couple of well defined and well described policies, from which the user will be able to pick the specific one per cluster, with an option to override it per VM.
The policies will differ in aggressiveness and in safety (e.g. switch to post-copy which guarantees that the VM will be moved and start working on the destination with the risk that it will stop running if anything wrong happens). For more details about post-copy migration see [Policies](#policies).
The proposed solution to enhance issue #2 is to expose the max incoming/outgoing migrations and the max bandwidth as configurable cluster level values and configure them from engine.
The proposed solution for #3 is to ensure that AQM is used on outbound if and possibly create hierarchical traffic shaping structure.
The proposed solution for #4 is to provide infrastructure to add guest agent hooks which will be notified before the migration starts and after the migration finishes so they can e.g. flush caches or turn off/on services which are not that critical.

## Owner

*   Name: Tomas Jelinek (TJelinek)
*   Email: jelinek@redhat.com
*   BZ: [https://bugzilla.redhat.com/show_bug.cgi?id=1252426](https://bugzilla.redhat.com/show_bug.cgi?id=1252426)

## VDSM Changes

### Policies

Currently the policies handling migrations are in VDSM - the monitor thread which aborts a migration after a certain time of stalling and the downtime thread which is enlarging the downtime. The proposal is to expose the settings of the migration parameters during migration. This way the engine will be able to implement number of different policies and also to expose the creation of the policies to user.

*   Enrich the migrate verb so it will contain the following parameters
    -   Current parameters:
        -   **hiearchical**: remote host or hibernation image filename
        -   **dstparams**: hibernation image filename for VDSM parameters
        -   **mode** remote/file
        -   **method**: online
        -   **downtime**: allowed down time during online migration
        -   **consoleAddress**: remote host graphics address
        -   **dstqemu**: remote host address dedicated for migration
        -   **compressed**: compress repeated pages during live migration (XBZRLE)
        -   **autoConverge**: force convergence during live migration
    -   Newly proposed:
        -   **maxBandwidth**: the maximal bandwidth which can be used by migrations. Optional argument, default migration_max_bandwidth from conf. It is an absolute value and applies only to the current migration (currently 32MiBps)
        -   **convergenceSchedule**: two lists - init and stalling
            -   **init**: list of actions which will be executed before migration
            -   **lastItems**: list of actions will be executed after all the "stalling" items have been executed
            -   **stalling**: list of pairs: (stallingLimit, action) where
              -   **stallingLimit**: if the migration is stalling(not progressing) for this amount of qemu iterations, execute the action and move to next pair
              -   **action**: one of:
                  -   **setDowntime(N)**: sets the maximum downtime to N
                  -   **abort**: abort migration
                  -   **postcopy**: change to post-copy
              -   This schedule will effectively replace the "migration_progress_timeout" from vdsm.conf (e.g. if the VM is stalling for this amount of time, VDSM aborts the migration). The whole **convergenceSchedule** is an optional argument, default: migration_progress_timeout from conf (150s)

An example how the **convergenceSchedule** would look like:

    {"initialItems":[{"action":"setDowntime","params":["100"]}], "convergenceItems": [{"stallingLimit":1,"convergenceItem":{"action":"setDowntime","params":["150"]}},{"stallingLimit":2,"convergenceItem":{"action":"setDowntime","params":["200"]}}], "lastItems":[{"action":"abort", "params":[]}]}

The behavior of the VDSM in this case will be as follows:

*   Starts the migration with the **downtime** 100 (from initialItems)
*   In the monitor thread monitors the migration
*   If the migration progresses, does nothing, just keeps monitoring
*   If it detects that the qemu started a new iteration, execute setDowntime 150
*   If it detects that the qemu started a new iteration, execute setDowntime 200
*   After this, if the qemu starts yet an another iteration, since all the items from policy are exhausted the abort the migration (the last item)
*   Add a new verb called **migrateChangeParams** with the following parameters:
    -   **vmID**: vm UUID
    -   **convergenceSchedule**: list of pairs: (stallingLimit, action) where
    -   **maxBandwidth**: the maximal bandwidth which can be used by migrations. Optional argument, default migration_max_bandwidth from conf (32 MiBps)

When this verb will be called, the VDSM will store the new "last will" of the engine (e.g. the **convergenceSchedule**) and apply the new **maxBandwidth** immediately.

### Bandwidth

Currently, the bandwidth is set in migration_max_bandwidth in the VDSM conf and can not be tuned from engine. There is also no way to set the max incoming migrations. The proposed changes are:

*   Add max_incoming_migrations (in addition to existing max_outgoing_migrations) to VDSM conf. It will mean how many incoming migrations are allowed on one host. This should help against migration storms (several hosts going NonOperational starting evacuating all VMs to the last few remaining hosts)
*   The migrationCreate will guard to not have more than max_incoming_migrations. It shall refuse to create the VM when exceeded.
*   When the migrationCreate refuse to create the VM, this VM will go back to the pool of VMs waiting for migrations (on the source host). It will be implemented only by releasing the lock and trying to acquire it again later (so other threads waiting on the same lock will have a chance to get the lock and possibly start migrating to a different host)
*   The incoming and outgoing migrations will have different semaphores
*   The bandwidth will be taken from the **migrate** verb's **maxBandwidth** parameter
*   A new verb **migrateChangeGlobalParams** will be added which will change the current values of the num of concurrent migrations for the given host (e.g. override the ones from vdsm.conf). It will have the following params:
    -   **max_outgoing_migrations**: same meaning as in vdsm.conf
    -   **max_incoming_migrations**: same meaning as in vdsm.conf
*  The bandwidth will be a cluster level setting with this 3 possible values:
    -   **hypervisor default**: the setting from vdsm.conf is going to be set
    -   **Manual**: the user sets any value in mbps
    -   **Auto**: default option. It will take the max bandwidth from the SLA setting on the migration network. If not set, it will take it as a minimum from the link speed of the network interfaces which are assigned to the migration network. If the link speed is not reported, than the hypervisor default is going to be used as a fallback

In case of manual and auto the actual bandwidth for one migration is the bandwidth / max concurrent migrations (the max concurrent migration taken from migration policy)

### Traffic shaping

At the moment, VDSM doesn't use traffic shaping or any other kind of traffic control. Traffic shaping can result in better migration performance (downtime, convergence, latency...) in most of network situations when using some kind of Active Queue Management (AQM) .e.g CODEL or FQ_CODEL. More importantly by guaranteeing a minimal QoS of the management traffic it should help preventing erratic communication between the host and the engine (timeouts/disconnects, hosts going NonResponsive)

VDSM should

*   ensure that AQM is used on outbound if,
*   possibly create hierarchical traffic shaping structure.

#### References

[https://bugzilla.redhat.com/show_bug.cgi?id=1255474](https://bugzilla.redhat.com/show_bug.cgi?id=1255474)

This part is targeted to 4.1

## Engine Changes

*   Migration bandwidth will be set per cluster
*   Engine will implement policies which will contain:
    -   **Max concurrent migrations allowed**: both outgoing and incoming
    -   **Migration compression allowed**: qemu will send the memory pages compressed
    -   **Autoconvergence allowed**: qemu will be slowing the VM down during migration if the migration will not be progressing
    -   **Guest hooks allowed**: oVirt guest agent will be notified to notify hooks that the migration started/finished
    -   **convergence config**: The specific list of actions which have to happen before migration, during stalling of migration and as a last step

### Policies

The internals of the policies are going to be hidden from the user and exposed only as well named and well described structures.
The only way how the user will be able to create his own policy or modify the existing ones will be using the engine-config tool.

#### Specific Policies

There will be 4 specific policies:

*   **Legacy**: fallback to the default VDSM policy (downtime thread and monitoring thread)
*   **Minimal Downtime**: the downtime will be linearly increased until the limit and than the migration will be aborted. The difference between this policy and the "Legacy" is that this policy reacts to qemu iterations instead of time so it increases the downtime when the migration is actually stalling. In detail (downtimes in milliseconds):
    -   **max migrations in parallel**: 2
    -   **auto convergence**: enabled
    -   **migration compression**: enabled
    -   **guest agent events**: enabled
    -   **schedule**:
        -   initial downtime: 100
        -   stalling 1 iteration, set downtime to 150
        -   stalling 2 iteration, set downtime to 200
        -   stalling 3 iteration, set downtime to 300
        -   stalling 4 iteration, set downtime to 400
        -   stalling 6 iteration, set downtime to 500
        -   if still stalling, abort
*   **Post-copy migration**: Similar to the previous one, but the last step is to turn to post-copy migration. [Post-copy migration](http://wiki.qemu.org/Features/PostCopyLiveMigration#Summary) guarantees that the migration will eventually converge, with very short downtime. Nevertheless there are also disadvantages. In the post-copy phase the VM may slow down significantly as the missing parts of memory contents are transferred between the hosts on demand. And if anything wrong happens during the post-copy phase (e.g. network failure between the hosts) then the running VM instance is lost; for that reason it is not possible to abort a migration in the post-copy phase. Will be available in oVirt 4.1.
*   **Suspend workload if needed**: Similar to the "Minimal Downtime". The difference is there are 2 end actions - first it sets a very high downtime (5 seconds) and only if even this does not help, abort the migration. In detail (downtimes in milliseconds):
    -   **max migrations in parallel**: 1
    -   **auto convergence**: enabled
    -   **migration compression**: enabled
    -   **guest agent events**: enabled
    -   **schedule**:
        -   initial downtime: 100
        -   stalling 1 iteration, set downtime to 150
        -   stalling 2 iteration, set downtime to 200
        -   stalling 3 iteration, set downtime to 300
        -   stalling 4 iteration, set downtime to 400
        -   stalling 6 iteration, set downtime to 500
        -   if still stalling, set downtime to 50000
        -   if still stalling, abort

#### Defining Custom Policies / Changing Existing Ones
The only way how a policy can be defined / edited is using the engine-config tool (MigrationPolicies key). To list the current migration policies:

    ./engine-config -g MigrationPolicies

It will return a list of JSON formatted policies, will look like this (it will return it unformatted):

    [  
     {  
      "id":{  
         "uuid":"80554327-0569-496b-bdeb-fcbbf52b827b"
      },
      "maxMigrations":2,
      "autoConvergence":true,
      "migrationCompression":true,
      "enableGuestEvents":true,
      "name":"Minimal downtime",
      "description":"A safe policy which in typical situations lets the VM converge. The VM  user should not notice any significant slowdown of the VM. If the VM is not converging for a long time, the migration will be aborted. The guest agent hook mechanism is enabled.",
      "config":{  
         "convergenceItems":[  
            {  
               "stallingLimit":1,
               "convergenceItem":{  
                  "action":"setDowntime",
                  "params":[  
                     "150"
                  ]
               }
            },
            {  
               "stallingLimit":2,
               "convergenceItem":{  
                  "action":"setDowntime",
                  "params":[  
                     "200"
                  ]
               }
            },
            {  
               "stallingLimit":3,
               "convergenceItem":{  
                  "action":"setDowntime",
                  "params":[  
                     "300"
                  ]
               }
            },
            {  
               "stallingLimit":4,
               "convergenceItem":{  
                  "action":"setDowntime",
                  "params":[  
                     "400"
                  ]
               }
            },
            {  
               "stallingLimit":6,
               "convergenceItem":{  
                  "action":"setDowntime",
                  "params":[  
                     "500"
                  ]
               }
            }
         ],
         "initialItems":[  
            {  
               "action":"setDowntime",
               "params":[  
                  "100"
               ]
            }
         ],
         "lastItems":[  
            {  
               "action":"abort",
               "params":[  

               ]
            }
         ]
      }
    },
    {  
      "id":{  
         "uuid":"80554327-0569-496b-bdeb-fcbbf52b827c"
      },
      "maxMigrations":1,
      "autoConvergence":true,
      "migrationCompression":true,
      "enableGuestEvents":true,
      "name":"Suspend workload if needed",
      "description":"A safe policy which makes also a highly loaded VM converge in most situations. On the other hand, the user may notice a slowdown. If the VM is still not converging, the migration is aborted. The guest agent hook mechanism is enabled.",
      "config":{  
         "convergenceItems":[  
            {  
               "stallingLimit":1,
               "convergenceItem":{  
                  "action":"setDowntime",
                  "params":[  
                     "150"
                  ]
               }
            },
            {  
               "stallingLimit":2,
               "convergenceItem":{  
                  "action":"setDowntime",
                  "params":[  
                     "200"
                  ]
               }
            },
            {  
               "stallingLimit":3,
               "convergenceItem":{  
                  "action":"setDowntime",
                  "params":[  
                     "300"
                  ]
               }
            },
            {  
               "stallingLimit":4,
               "convergenceItem":{  
                  "action":"setDowntime",
                  "params":[  
                     "400"
                  ]
               }
            },
            {  
               "stallingLimit":6,
               "convergenceItem":{  
                  "action":"setDowntime",
                  "params":[  
                     "500"
                  ]
               }
            }
         ],
         "initialItems":[  
            {  
               "action":"setDowntime",
               "params":[  
                  "100"
               ]
            }
         ],
         "lastItems":[  
            {  
               "action":"setDowntime",
               "params":[  
                  "5000"
               ]
            },
            {  
               "action":"abort",
               "params":[  

               ]
            }
         ]
      }
     }
    ]


The "Legacy" policy can not be edited since it is not an actual policy but a fallback to the way how VDSM is handling the migrations.

The policies can be edtied using the:

    ./engine-config -s MigrationPolicies='the actual content'

Where the actual content is the whole unformatted JSON document.

##### Format of the Policy
The policy has two parts:

*     **id**: The UUID of the policy. Used by REST API and by frontend to assign this policy with the cluster/VM
*     **name**: The name which shows up in webadmin cluster dialog as the policy name
*     **description**: The description which shows up in webadmin after picking the policy
*     **maxMigrations**: How many migrations in parallel are allowed per each host in the cluster. If for example 2, than max 2 outgoing migrations and 2 incoming migrations are allowed. Please note that the migration bandwidth is divided by this value. E.g. if the migration bandwidth is set to 100Mbps and 2 parallel migrations are allowed than each migration will be allowed to take 50Mbps even if only one is currently performed.
*     **enableGuestEvents**: true/false if the guest agent should or should not be notified about the start/finish of the migration
*     **autoConvergence**: true/false to enabled/disable the quemu auto convergence feature
*     **migrationCompression**: true/false to enable/disable the qemu migration compression feature
*     **config**: an object containing 3 secions:
       -   **initialItems**: List of actions which has to be executed before the migration starts. The items of the list are objects containing:
           -    **action**: possible value: **setDowntime**. Sets the migration downtime to a value provided in the params
           -    **params**: list of parameters of the action. For the **setDowntime** the actual downtime value in milliseconds
       -   **convergenceItems**: List of actions which will be executed during migrations if the migration is stalling. The items of the list are objects containing:
           -    **stallingLimit**: integer, how many qemu iterations to wait until executing this action
           -    **convergenceItem**: an object describing what action to perform when the migration is stalling. Contains:
                -    **action**: possible value: **setDowntime** or **abort** for setting the downtime or aborting the migration respectively
                -    **params**: list of parameters of the action. For the **setDowntime** the actual downtime value in milliseconds, for **abort** an empty list
       -   **lastItems**: List of items to execute if all the items from the **convergenceItems** has been executed and the migration is still stalling. Possible values are the same as for convergence items, but the stalling limit can not be set. If more than one item is set, they will be executed one by one after each qemu iteration.

## REST API
In REST API the migration policies can be referenced but can not be edited/added or modified. For this the engine-config tool has to be used.

### Cluster

The policy tag has been added to represent the policy.

The Legacy migration policy is referenced as:

    <policy id="00000000-0000-0000-0000-000000000000"/>

Other policies are referenced as

    <policy id="the policy id"/> 

The bandwidth is referenced as:

    <bandwidth>
        <assignment_method>the assignement method</assignment_method>
    </bandwidth>

the assignment_method can be:

*   auto
*   hypervisor_default
*   custom (this takes one more argument, the custom_value):

An example of the custom policy:

    <bandwidth>
      <assignment_method>custom</assignment_method>
      <custom_value>12</custom_value>
    </bandwidth>


### VM
The migration policy is present only if overridden by the VM. If it is not there it means that the Cluster policy is used.
For example:
If overridden to "Legacy":

    <migration>
      <auto_converge>inherit</auto_converge>
      <compressed>inherit</compressed>
      <policy id="00000000-0000-0000-0000-000000000000"/>
    </migration>

If it is not overridden:

    <migration>
      <auto_converge>inherit</auto_converge>
      <compressed>inherit</compressed>
    </migration>

To remote override, send an empty policy:

    <migration>
      <auto_converge>inherit</auto_converge>
      <compressed>inherit</compressed>
      <policy />
    </migration>

The bandwidth is not present for VM - this property can be configured only per cluster.

### Default Migration Policy IDs
In order to be able to reference a policy using REST API the policy ID has to be provided. You can obtain the specific policy ID using engine-config tool. oVirt comes by default with 2 pre-configured migration policies:

*    **Minimal Downtime**: 80554327-0569-496b-bdeb-fcbbf52b827b
*    **Suspend workload if needed**: 80554327-0569-496b-bdeb-fcbbf52b827c
