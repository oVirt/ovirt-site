---
title: TestCase Hosted Engine External Gluster Support
category: testcase
authors: sandrobonazzola
wiki_category: TestCase|Hosted_Engine_External_Gluster_Support
wiki_title: QA:TestCase Hosted Engine External Gluster Support
wiki_revision_count: 1
wiki_last_updated: 2015-04-03
---

# TestCase Hosted Engine External Gluster Support

## Description

Starting with oVirt 3.6.0 Hosted Engine can be deployed on a existing GlusterFS Replica 3 storage. This test case will check that the feature is working as expected.

## Setup

*   Prepare a Gluster Replica 3 storage to be used. You can follow [Creating Replicated Volumes](https://access.redhat.com/documentation/en-US/Red_Hat_Storage/2.1/html/Administration_Guide/sect-User_Guide-Setting_Volumes-Replicated.html) guide
*   Configure Gluster servers ensuring ***/etc/glusterfs/glusterd.vol*** setting

         option rpc-auth-allow-insecure on

*   Configure the volume to be used as following:

        gluster volume set `<volume>` cluster.quorum-type auto
        gluster volume set `<volume>` network.ping-timeout 10
        gluster volume set `<volume>` auth.allow \*
        gluster volume set `<volume>` group virt
        gluster volume set `<volume>` storage.owner-uid 36
        gluster volume set `<volume>` storage.owner-gid 36
        gluster volume set `<volume>` server.allow-insecure on

## How to test

1.  Install ovirt-hosted-engine-setup
2.  Run hosted-engine --deploy
3.  When asked about *Please specify the storage you would like to use* select glusterfs
4.  Specify the volume prepared for the test
5.  Complete the Hosted Engine deployment

## Expected Results

*   The Hosted Engine deployment is completed without errors

## Optional

*   Deploy additional hosts for Hosted Engine

[Hosted_Engine_External_Gluster_Support](Category:TestCase)
