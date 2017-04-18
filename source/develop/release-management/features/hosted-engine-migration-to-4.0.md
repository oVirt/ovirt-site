
# Migration path (proposal):
- engine-backup all backup6to7.tar.gz
- Add disk to hosted engine VM (Allow that in edit VM?)
- extract the disk content from the 4.0 appliance (reuse the setup functionality)
- Edit the new disk boot order to boot 1st. Make sure OVF is rewritten
- Shutdown the VM using --vm-shutdown and start it --vm-start
- put Hosted engine to maintenance mode
- VM boots, cloud-init performs engine-setup, and engine-backup restore backup6to7.tar.gz 
- put hosted engine maintenance mode=none

# Revert
- hosted-engine --vm-start --vm-conf=vm_with_the_old_disk.conf
- Edit engine VM disk boot order, set the old disk to boot 1st or remove the new disk
- wait for OVF to persist
- restart vm using cli

# UI, REST
- ?

