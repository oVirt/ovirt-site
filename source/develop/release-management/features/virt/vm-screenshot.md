---
Title: VM Screenshot
Category: feature
Authors: sabusale
---

# VM Screenshot

## Summary

Allow users to take screenshot of a running VM

## Owner

*   Name: Saif Abu Saleh (sabusale)
*   Email: sabusale@redhat.com

## Description

Users need a way to see the current state of their VMs for debug purposes,
when they don't have console access

### UI

Not supported

### VDSM

VDSM will call Libvirt screenshot API [[2]]

Libvirt will call QEMU to capture the screenshot

then VDSM will return `ppm` file content as base64 string



### Backend

Backend will call VDSM to capture screenshot and will receive base64 string screenshot
and then base64 string will be converted to byte array and returned

### REST API

Rest API will call Backend to capture the screenshot

Rest API call is synchronous operation

Rest API implementation is intended for debugging only

API call Example:

`/vms/{vm:id}/screenshot`

```
      POST /vms/1234/screenshot
      Accept: application/xml
```

Response is a byte array of the screenshot
```
iVBORw0K..
```

### Image format issues

`ppm` is not a standard screenshot format, and users may have issues to see the screenshot, and it is not straight forward
to display it in HTML[[4]], unlike e.g. `png base64`

issue[[5]] opened to QEMU to add screen dump as PNG

other option is to convert the `ppm` content to other standard format like `png`
ways to convert it:
*   Convert it in VDSM using PIL image library: [example](https://stackoverflow.com/questions/69675903/how-do-i-use-python-image-library-to-convert-a-libvirt-stream-to-a-different-ima)
*   In Engine use java API to convert it using [ImageMagick](https://stackoverflow.com/a/2291493/5825468)

### Future work
*   Add the functionality to web UI
*   Libvirt screenshot API provides option to capture screenshot by screen number (in case there are multiple screens).

    for now by default 0 only used(first screen),
    add the option to take screenshot by screen number
    
* Change generate screenshot API call to be asynchronous


[1]: https://fileinfo.com/extension/ppm
[2]: https://libvirt.org/docs/libvirt-appdev-guide-python/en-US/html/ch12s02.html
[3]: https://github.com/qemu/qemu/blob/0289f62335b2af49f6c30296cc00d009995b35f6/ui/console.c#L420
[4]: https://stackoverflow.com/a/41647242/5825468
[5]: https://gitlab.com/qemu-project/qemu/-/issues/718