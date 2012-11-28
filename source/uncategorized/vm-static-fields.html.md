---
title: Vm static fields
authors: ofrenkel
wiki_title: Vm static fields
wiki_revision_count: 3
wiki_last_updated: 2012-11-29
wiki_conversion_fallback: true
wiki_warnings: conversion-fallback
---

# Vm static fields

**List of fields for vm / template / instance type**

field name

description

instance type

template

editable by user

permissions needed

vm_guid

internal. uniqe identifier

n

n

n

none

vm_name

name

n

n

y

create instance

mem_size_mb

memory size

y

y

n

create instance

vmt_guid

internal. link to template object

n

n

none

os

os type

y

description

description

n

n

y

create instance

vds_group_id

vm cluster

n

y

y

change cluster

domain

directory services domain

y

creation_date

internal. creation date

n

n

n

none

num_of_monitors

number of monitors

y

is_initialized

internal. mark if vm was syspreped

y

is_auto_suspend

legacy from auto-suspend feature, not in use

y

num_of_sockets

number of sockets

y

cpu_per_socket

cpu per socket

y

usb_policy

usb policy

y

time_zone

time zone

y

is_stateless

stateless flag

y

fail_back

legacy from fail-back feature, not in use

y

dedicated_vm_for_vds

specific host for running vm

y

auto_startup

HA

y

vm_type

vm type (server/desktop)

y

nice_level

vm nice level

y

default_boot_sequence

boot sequence

y

default_display_type

display type

y

priority

priority

y

iso_path

cd

y

origin

internal. where the vm was created

n

initrd_url

boot params

y

kernel_url

boot params

y

kernel_params

boot params

y

migration_support

migration support options

y

userdefined_properties

custom properties

y

predefined_properties

custom properties

y

min_allocated_mem

memory guaranteed

y

child_count

internal. for template, not in use?

quota_id

link to quota

allow_console_reconnect

allow reconnect to console

y

console reconnect

cpu_pinning

cpu pinning

y

is_smartcard_enabled

smartcard enabled

y

instance_type_id

internal. link to instance type

n

payload

payload (device, not in vm_static)
