# VDSM Hook Return Codes

Hook scripts must return one of the return codes shown in [hook-return-codes](hook-return-codes). The return code will determine whether further hook scripts are processed by VDSM.

**Hook Return Codes**

| Code | Description |
|-
| 0 | The hook script ended successfully |
| 1 | The hook script failed, other hooks should be processed |
| 2 | The hook script failed, no further hooks should be processed |
| >2 | Reserved |
