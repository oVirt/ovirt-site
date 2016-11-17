# CPU Requirements

All CPUs must have support for the Intel® 64 or AMD64 CPU extensions, and the AMD-V™ or Intel VT® hardware virtualization extensions enabled. Support for the No eXecute flag (NX) is also required.

**Supported Hypervisor CPU Models**

| AMD | Intel | IBM |
|-
| AMD Opteron G1 | Intel Conroe      | IBM POWER8 |
| AMD Opteron G2 | Intel Penryn      | |
| AMD Opteron G3 | Intel Nehalem     | |
| AMD Opteron G4 | Intel Westmere    | |
| AMD Opteron G5 | Intel Sandybridge | |
|                | Intel Haswell     | |

**Checking if a Processor Supports the Required Flags**

You must enable Virtualization in the BIOS. Power off and reboot the host after this change to ensure that the change is applied.

1. At the Red Hat Enterprise Linux or Red Hat Virtualization Host boot screen, press any key and select the **Boot** or **Boot with serial console** entry from the list.

2. Press **Tab** to edit the kernel parameters for the selected option.

3. Ensure there is a **Space** after the last kernel parameter listed, and append the `rescue` parameter.

4. **Enter** to boot into rescue mode.

5. At the prompt which appears, determine that your processor has the required extensions and that they are enabled by running this command:

        # grep -E 'svm|vmx' /proc/cpuinfo | grep nx

    If any output is shown, then the processor is hardware virtualization capable. If no output is shown, then it is still possible that your processor supports hardware virtualization. In some circumstances manufacturers disable the virtualization extensions in the BIOS. If you believe this to be the case, consult the system's BIOS and the motherboard manual provided by the manufacturer.
