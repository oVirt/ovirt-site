---
title: Gluster Arbiter Volume
category: feature
authors: rnahcimu, sahina
wiki_category: Feature|ArbiterVolume
wiki_title: Features/Gluster Arbiter Volume
wiki_revision_count: 13
wiki_last_updated: 2016-01-25
feature_name: Gluster Arbiter Volume
feature_modules: all
feature_status: Inception
---

# Gluster Arbiter Volume

# Summary

Arbiter volumes are replica 3 volumes where the 3rd brick of the replica is automatically configured as an arbiter node. What this means is that the 3rd brick will store only the file name and metadata, but does not contain any data. This configuration is helpful in avoiding split-brains while providing the same level of consistency as a normal replica 3 volume. This features allows Gluster Storage Administrator to create and manager Arbiter Volumes from oVirt.

To read more about Gluster volume snapshot feature, see <https://gluster.readthedocs.org/en/release-3.7.0/Features/afr-arbiter-volumes/>

# Owner

*   Name: [ Ramesh Nachimuthu](User:Rnahcimu)
*   Email: <rnachimu@redhat.com>

# Detailed Description

       Arbiter volume is a replica 3 volumes with 3rd being a arbiter brick. Arbiter brick will store only metadata so it will not require the same storage capacity as other bricks. In a way, it helps to get the benefits of Replica 3 (specially avoiding split-brain) volume with one arbiter brick. 

# Design

### User Experience and control flows

### Limitations

NA

Refer the URL: <http://www.ovirt.org/Features/Design/GlusterVolumeSnapshots> for detailed design of the feature.

# Dependencies / Related Features and Projects

None

# Test Cases

# Documentation / External references

# Comments and Discussion

# Open Issues

[ArbiterVolume](Category:Feature) <Category:Gluster> [GlusterArbiterVolume](Category:oVirt 4.0 Proposed Feature)
