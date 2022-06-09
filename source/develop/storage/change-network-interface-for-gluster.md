---
title: Change network interface for Gluster
authors:
  - dneary
  - jplorier
  - sahina
  - sven
---

# Change network interface for Gluster

The purpose of this page is to describe how to allow Gluster network traffic to use other network interface than ovirtmgmt.
By default, oVirt shows the hosts in the cluster with their ovirmgmt IPs.
This can cause problems under heavy network activity, mostly when Gluster uses the network to syncronize big amounts of data.
In this scenario, oVirt looses touch with the host and can cause the host to be marked as unreachable and thus trigger VMs migrations.
To avoid this, you may use extra NICs in your hosts to create a network for Gluster's traffic.
You can be in two scenarios; you already have your Gluster storage domain created and can't start over from the top, or you can get yourself a fresh start.
This guide is to allow you to start over, but though I didn't test it (anyone else may edit this) I think that you can use the same strategy to migrate your bricks to a new IP.

***Note : There's currently no easy mechanism to migrate a gluster host IP to a new IP.***

Fist, you have to set up your Glusterfs domain in order to have the hosts that will act as bricks.
I found that if you use replica, you have to be aware that in the future, you may only add a multiple of replica of bricks to the volume.
By default, the hosts are set as peer with the ovirmgmt IP, so if you have a working volume with replica and can't remove it,
you may need to figure how to add more bricks to replace the ones you need to modify.

**WARNING**: I didn't test this procedure on existing volumes, so be sure to test it before risking your data.

If you use the volume in a storage domain, remove the storage domain to release the volume.
Now you need to manualy edit Gluster's properties from the cli.
If you need to maintain your volume, skip the deletion part and try to adapt the next part to your needs. Log into one of them and stop and remove any existing volume (if any):

List your volumes:
```console
# gluster volume list
```

Stop and delete the one you want to change. If your hosts are part of more than one volume, you may need to remove all of them to remove the peer or find a way to replace it with another.
```console
# gluster volume stop <Name of volume>
# gluster volume delete <Name of volume>
```

Now, lets list the peers enrolled and detach them to re add them with the new IP:

Show the hosts that act as peers to Gluster
```console
# gluster peer status
```

Detach every host you need to modify
```console
# gluster peer detach <IP of the host to modify>
```

Now, lets add them back with the new IP (**FQDN is the preferred way**):
```console
# gluster peer probe <New host's IP>
```

As we are starting over, we are going to remove any trace of the past volume, so we need to clean the directory and set labels back in place:
```console
# setfattr -x trusted.glusterfs.volume-id Path_to_brick
# setfattr -x trusted.gfid Path_to_brick
# rm -rf Path_to_brick/.glusterfs
```

Also, if you already used the volume as a Glusterfs Storage Domain in Ovirt, you need to clean Ovirt's data:
```console
# rm -rf Path_to_brick/*
```

***Note: You can also reuse existing bricks, by using the force option in the below command (available from gluster 3.5)***

Now we can create the volume again (stolen from man :-) ):
```console
# volume create <NEW-VOLNAME> [stripe <COUNT>] [replica <COUNT>] [device vg] [transport <tcp|rdma|tcp,rdma>] <NEW-BRICK>
```

The last thing to do is to set uid and gid of the volume to be vdsm:kvm as when you create a volume directly from Gluster those are set to root:
```console
# gluster volume set glusterfs storage.owner-uid 36
# gluster volume set glusterfs storage.owner-gid 36
```

I think this is also done when you hit "Optimize for virt". It's important to use this option as it sets several variables of the volume in order to have it tuned.

Hope this helps and as I'm no guru at Ovirt or Gluster, feel free to correct anything you think is wrong.
