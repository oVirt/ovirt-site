# Node Next FAQ

**1) What is Node Next?**

Node Next is the Node implementation from oVirt 4.0 , also known as NGN ( Next Generation Node ) or oVirt Node 4.

**2) What is the difference between oVirt Node and Node Next ?**

oVirt Node (vintage Node) was the Node implementation up to oVirt 3.x . 

1. In Vintage Node a custom installer was used  - in NGN, anaconda (CentOS/Fedora) installer is used.
2. In Vintage Node a text User-Interface was used for administration - In NGN, Cockpit is used.
3. In Vintage Node the file-system is Read-Only while NGN provide a writable file-system.

**3) Does Node Next work with oVirt 3.6 ?**

Yes. Special configuration is not needed.

**4) How can I install Node Next ?**

See [node/#quickstart/](/develop/projects/node/node/#quickstart/) 

**5) How can I update Node Next ?**

Use ``` yum update ``` 

After installation a user can use yum update to update Node.

In future (oVirt 4.0) Node Next can also be updated through Engine

In order to upgrade to the next major Node Next release (or to an unstable version) which is available in a different repository, run the following script with the relevant ovirt repository you would like to upgrade to:
- *ovirt-4.1* (4.1 GA channel)
- *ovirt-4.1-pre* (4.1 RC channel)
- *ovirt-4.1-snapshot* (4.1 Nightly channel)
- *ovirt-4.2* (4.2 GA channel)
- *ovirt-4.2-pre* (4.2 RC channel)
- *ovirt-4.2-snapshot* (4.2 Nightly channel)

```bash
#!/bin/bash -e

[[ $# -ne 1 ]] && echo "Usage $0 <new-ovirt-repo>" && exit 1

newrepo=$1

repoid=$(yum repolist "ovirt-4.*" | grep -Po "ovirt-4.[0-9](?=/)")
repofile=$(yum repoinfo $repoid | grep -Po "(?<=Repo-filename: ).*")
tmpfile=$(mktemp -t $newrepo.repo.XXXXX)

echo "Using $repofile to create $tmpfile"

sed "s/$repoid/$newrepo/" $repofile > $tmpfile

yum --disablerepo="*" --enablerepo="$newrepo" -c $tmpfile update
```

**6) Can I install Node NG from a flash disk ?**

Yes, first install the livecd-tools package and use livecd-iso-to-disk to transfer the ISO content to the disk.

```# yum install livecd-tools```

```# livecd-iso-to-disk --format --reset-mbr <path-to-ovirt-node-ng.iso> <flash-disk-device>```

Next, since livecd-iso-to-disk does not work well on Fedora-25 and with ISOs that are shipped with a kickstart file like Node NG, we need to modify the new disk.  Assuming the flash disk device is /dev/sdb, run the following script on /dev/**sdb1**:

```bash
#!/bin/bash

[[ $# -ne 1 ]] && {
    echo "Usage: $0 <device>"
    exit 1
}

TARGET_DEV=$1
TARGET_UUID=$(blkid -s UUID -o value $TARGET_DEV)

[[ -z $TARGET_UUID ]] && {
    echo "Error: UUID not found for $TARGET_DEV"
    exit 2
}

echo "Using UUID=$TARGET_UUID"

echo "Disabling 64bit on $TARGET_DEV"
e2fsck -f $TARGET_DEV
resize2fs -s $TARGET_DEV

echo "Fixing LABEL entries in conf"
TMPDIR=$(mktemp -d)
mount $1 $TMPDIR

CFG_FILE=$TMPDIR/syslinux/extlinux.conf
TARGET_LBL="UUID=$TARGET_UUID"

[[ -f $CFG_FILE ]] && { 
    sed -i -e "s/LABEL=[^ :]*/$TARGET_LBL/g" $CFG_FILE 
}

umount $TMPDIR
rmdir $TMPDIR
```
