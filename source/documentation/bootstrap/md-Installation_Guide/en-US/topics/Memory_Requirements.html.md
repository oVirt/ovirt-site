# Memory Requirements

The amount of RAM required varies depending on guest operating system requirements, guest application requirements, and memory activity and usage of guests. You also need to take into account that KVM is able to overcommit physical RAM for virtualized guests. This allows for provisioning of guests with RAM requirements greater than what is physically present, on the basis that the guests are not all concurrently at peak load. KVM does this by only allocating RAM for guests as required and shifting underutilized guests into swap.

**Memory Requirements**

| Minimum     | Maximum     |
| 2 GB of RAM | 2 TB of RAM |
