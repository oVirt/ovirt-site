# Uploading the VirtIO and Guest Tool Image Files to an ISO Storage Domain

The example below demonstrates the command to upload the `virtio-win.iso`, `virtio-win_x86.vfd`, `virtio-win_amd64.vfd`, and `rhev-tools-setup.iso` image files to the `ISODomain`.

**Uploading the VirtIO and Guest Tool Image Files**

    # engine-iso-uploader --iso-domain=[ISODomain] upload /usr/share/virtio-win/virtio-win.iso /usr/share/virtio-win/virtio-win_x86.vfd /usr/share/virtio-win/virtio-win_amd64.vfd /usr/share/rhev-guest-tools-iso/rhev-tools-setup.iso

