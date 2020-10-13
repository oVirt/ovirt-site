---
title: FenceAgents
authors: oliel
---

# Fence Agents

Until now oVirt supported up to two fence-agents, dubbed 'primary' and 'secondary', for the power management of a host.
These agents were run sequentially or concurrently according to a flag in the host's power-management.
In the API they were displayed and manipulated in the context of a Host, inside the host's power-management configuration:

* **GET** / **POST** / **PUT** `/api/hosts/{host:id}`

```xml
   <host>
      <power_management>
         <agent>...</agent>
         <agent>...</agent>
       </power_management>
   </host>
```

This structure posed difficulties when wanting to delete or update agents, and also was not scalable. This feature implements an improved API structure, which is propagated all the way down to the database level. Fence-agents are now business entities in their own right and have their own IDs and context in the API:

* **GET** `/api/hosts/{host:id}/fenceagents`
* **GET** / **POST** / **PUT** / **DELETE** `/api/hosts/{host:id}/fenceagents/{fenceagnet:id}`

```xml
   <agents>
     <agent id=”xxx”>
       <type>apc</type>
       <order>1</order>
       <ip>1.1.1.1</ip>
       <user>ori</user>
       <password>xxx</password>
       <port>9</port>
       <options>name1=value1, name2=value2</options>
     </agent>
   </agents>
```

the new 'order' field of the agents determines whether agents are run concurrently or sequentially, instead of the now-deprecated 'concurrent' flag inside the power-management element. Agents are run sequentially according to their order until the fence action succeeds, and if at any step along the way two or more agents have the same order, those agents are run concurrently.

See [the patch in gerrit](http://gerrit.ovirt.org/27578)
