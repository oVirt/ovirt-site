---
title: SPMPriority
category: template
authors: derez, msalem, ovedo
wiki_category: Template
wiki_title: Features/SPMPriority
wiki_revision_count: 16
wiki_last_updated: 2014-07-13
feature_name: SPM Priority
feature_modules: engine
feature_status: Released
wiki_warnings: list-item?
---

# SPM Priority

------------------------------------------------------------------------

## Summary

The SPM Priority feature allows the admin to define priorities between hosts regarding the SPM selection process. A host can be given priority -1 which means this host can not be selected to be the SPM.

## Owner

*   Feature owner: [ Muli Salem](User:msalem)

    * Engine Component owner: [ Muli Salem](User:msalem)

    * GUI Component owner: [ ?](User:?)

    * API Component owner: [ Muli Salem](User:msalem)

    * QA Owner: [ Leonid Natapov](User:lnatapov)

*   Email: msalem@redhat.com

## Current status

*   Status: Engine-done, API-done, QA-test plan built, GUI-design
*   Last updated date: Tue Dec 27 2011:

## Description

Currently, the SPM selection process is random, meaning a host is chosen randomly out of the hosts that are currently UP. The SPM Priority feature will allow admins to define the hosts that they prefer to be chosen as SPM.

## PRD

The requirements are the following:

1.  Enable setting a priority between -1 and 10 for a host (10 is the highest, -1 means never to choose this host).
2.  When SPM selection process takes place, use the SPM priority to select an SPM.
3.  Default for upgrading ovirt will be 5.

## Design

Current flow:

1.  All hosts that are "UP", and that have not been attempted to be chosen as SPMs in the Data Center are fetched.
2.  One is chosen randomly, and the SPM Selection algorithm begins.
3.  Every host that fails to become the SPM, is added to a the mTriedVdssList of forbidden hosts.

New Design:

1.  Adding a vds_spm_priority field to vds_static (validated to be between -1 and 10).
    1.  This field is configurable upon host creation and host editing by the admin.

2.  Replacing the list that is fetched in stage one of the current flow, with a list of prioritized hosts (detailed algorithm below).

<span style="color:Teal">**vds_spm_priority**</span>:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Description |- |vds_spm_priority ||smallint || CHECK (vds_spm_priority between (-1) and 10) DEFAULT 5 ||The Spm priority of this vds |- |}

Algorithm for selecting a host according to priorities

------------------------------------------------------------------------

1.  Fetch all hosts that are "UP" in Data Center, and that have not been attempted to be chosen as SPMs in the Data Center. The selection will return the list ordered both by SPM Priority (desc), and secondly by RANDOM().
2.  The top host is chosen, and the SPM Selection algorithm begins.
3.  Every host that fails to become the SPM, is added to a the mTriedVdssList of forbidden hosts.

*   Ordering the hosts according to the SPM Priority will make sure that the priorities set by the admin will be taken under consideration.
*   Secondly, ordering them with RANDOM(), randomly sorts each sub group of hosts that have the same priority. This will prevent the same host from being chosen every time, in case there are several hosts with the same priority.

## Affected Commands

1.  AddVdsCommand - no change since the parameter held is of type VdsStatic.
2.  UpdateVdsCommand - no change since the parameter held is of type VdsStatic.

## REST API changes

The Host resource schema was changed, and now the storage_manager element is of type "StorageManager" instead of boolean.

The schema for the StorageManager type is as follows:

        <xs:element name="storage_manager" type="StorageManager"/>
            <xs:complexType name="StorageManager">
                <xs:simpleContent>
                    <xs:extension base="xs:boolean">
                        <xs:attribute name="priority" type="xs:int">
                        </xs:attribute>
                    </xs:extension>
                </xs:simpleContent>
            </xs:complexType>
       

## Open Issues

## Dependencies / Related Features

Affected ovirt projects:

*   API
*   CLI
*   backend
*   Webadmin
*   User Portal

## Documentation / External references

## Comments and Discussion

------------------------------------------------------------------------

<Category:Template> <Category:Feature>
