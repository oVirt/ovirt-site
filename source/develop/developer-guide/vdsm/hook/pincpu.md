---
title: pincpu
authors: dyasny
---

# pincpu

The pincpu hook will ping the VM's virtual CPUs to specific host CPUs. Can be used to map a VM to a specific subset of host CPUs in order to comply with specific licensing requirements or to improve performance under certain loads

Usage: pincpu="0" (use the first cpu) pincpu="1-4" (use cpus 1-4) pincpu="^3" (dont use cpu 3) pincpu="1-4,^3,6" (all of the above)

syntax:

      pincpu=1

will pin the vm to cpu 1

