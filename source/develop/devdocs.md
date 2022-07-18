---
title: Developer Documentation
category: developer
authors:
  - dneary
  - jbrooks
  - ykaplan
  - sandrobonazzola
  - gshereme
---

<section class="row">

<section class="col-md-12">

## Developer Documentation

<div class="alert alert-warning">
  Much of this developer documentation provides historical context but may not reflect the current state of the project.
  <br/>
  If you see outdated content please navigate to the page footer and click "<strong>Report an issue on GitHub</strong>".
  <br/>
  <br/>
  It is <strong>not</strong> user documentation and should not be treated as such.
  <br/>
  <br/>
  <a href="/documentation/">User documentation is available here.</a>
</div>

#### oVirt development teams

- [Infrastructure](infra/infrastructure.html)
- [Integration](integration/index.html)
- [oVirt Quality Assurance](qa/index.html)


#### Design Documentation
- [Feature Pages / Design Documentation](/develop/release-management/features/)
- [Overall architecture](./architecture/architecture.html)
- [oVirt Engine architecture](./architecture/index.html)


#### Developer Process
- [Migrating a project from Gerrit to GitHub](/develop/developer-guide/migrating_to_github.html)
- [Localization](/develop/localization.html)
- [New features template](/develop/release-management/features/feature-template.html)

Obsolete:
- [The development process](/develop/dev-process/devprocess.html)
- [Release management](/develop/release-management/process/release-process.html)
- [Becoming a maintainer](/develop/dev-process/becoming-a-maintainer.html)
- [How to license a project](/develop/projects/license-a-project.html)
- [New project acceptance criteria](/develop/projects/project-acceptance-criteria/graduation-check-list.html)

#### Release process
- [Adding a project to ovirt-master-snapshot COPR repository](/develop/release-management/process/add_a_package_to_copr.html)
- [Making an oVirt release](/develop/release-management/process/making-a-release.html)


#### Proposals
- [Better Vurti](/develop/release-management/proposals/better-vurti.html)
- [Entitiy comment](/develop/release-management/proposals/entity-comment.html)
- [Mass VMs run](/develop/release-management/proposals/mass-vms-run.html)
- [oVirt Engine disaster recovery](/develop/projects/proposals/ovirt-engine-disaster-recovery.html)
- [oVirt Vagrant provider](/develop/projects/proposals/vagrant-provider.html)

#### Development Help

- [Building oVirt engine](/develop/developer-guide/engine/engine-development-environment.html)
- [Install nightly snapshot](/develop/dev-process/install-nightly-snapshot.html)
- [Testing ovirt-engine patches with Lago](/develop/infra/testing/lago/testing-engine-patches-with-lago.html)
- [Building VDSM](/develop/developer-guide/vdsm/developers.html)
- [FAQ](/develop/faq.html)
- [HA VMs](/develop/ha-vms.html)
- [Migrate PKI to SHA256 signatures](/develop/migrate-pki-to-sha256.html)
- [Networking](/develop/networking/)
- [Internal](/develop/internal/)
- [Infra](/develop/infra/)
- [Resources](/community/get-involved/resources/)
- [SLA](/develop/sla/)
- [Storage](/develop/storage/)
- [Permission system](/develop/developer-guide/action-permissions-overview.html)
- [Audit Logs and Event Notifications](/develop/developer-guide/events/audit-logs-and-event-notifications.html)
- [Backend Bean Validation How-to](/develop/developer-guide/java/backend-bean-validation.html)
- [Backend with jrebel](/develop/developer-guide/java/backend-with-jrebel.html)

#### Containerization

- [Using oVirt Engine with a PostgreSQL container](/develop/Using-oVirt-Engine-with-a-PostgreSQL-container.html)
- [Using oVirt Engine with a ManageIQ container](/develop/Using-oVirt-Engine-with-ManageIQ-container.html)

#### Data Warehouse

- [DWH Development Environment](/develop/dwh-development-environment.html)
- [How to write patches for DWH](/develop/write-patches-for-dwh.html)

#### Storage

- [Troubleshooting NFS](/develop/troubleshooting-nfs-storage-issues.html)


#### VDSM Hooks
- [directlun](/develop/developer-guide/vdsm/hook/directlun.html)
- [faqemu](/develop/developer-guide/vdsm/hook/faqemu.html)
- [fileinject](/develop/developer-guide/vdsm/hook/fileinject.html)
- [floppy](/develop/developer-guide/vdsm/hook/floppy.html)
- [isolatedprivatevlan](/develop/developer-guide/vdsm/hook/isolatedprivatevlan.html)
- [network-nat](/develop/developer-guide/vdsm/hook/network-nat.html)
- [numa](/develop/developer-guide/vdsm/hook/numa.html)
- [pincpu](/develop/developer-guide/vdsm/hook/pincpu.html)
- [promisc](/develop/developer-guide/vdsm/hook/promisc.html)
- [qemucmdline](/develop/developer-guide/vdsm/hook/qemucmdline.html)
- [qos](/develop/developer-guide/vdsm/hook/qos.html)
- [scratchpad](/develop/developer-guide/vdsm/hook/scratchpad.html)
- [smartcard](/develop/developer-guide/vdsm/hook/smartcard.html)
- [smbios](/develop/developer-guide/vdsm/hook/smbios.html)
- [vhostmd](/develop/developer-guide/vdsm/hook/vhostmd.html)
- [vmdisk](/develop/developer-guide/vdsm/hook/vmdisk.html)
- [vmfex](/develop/developer-guide/vdsm/hook/vmfex.html)

#### Unit testing
- [Injector Extension](/develop/dev-process/unit-testing-utilities/injectorextension.html)
- [Mock Config Extension](/develop/dev-process/unit-testing-utilities/mockconfigextension.html)
- [Mock Config Rule](/develop/dev-process/unit-testing-utilities/mockconfigrule.html)
- [Random Utils Seeding Extension](/develop/dev-process/unit-testing-utilities/randomutilsseedingextension.html)
- [Random Utils Seeding Rule](/develop/dev-process/unit-testing-utilities/randomutilsseedingrule.html)
- [Testing Commands](/develop/dev-process/unit-testing-utilities/testing-commands.html)
- [Testing Queries](/develop/dev-process/unit-testing-utilities/testing-queries.html)

#### Other

- [User level query column filtering](/develop/user-level-query-column-filtering.html)
- [Migration from vdscli to jsonrpcvdscli](/develop/migration-from-vdscli-to-jsonrpcvdscli.html)
- [oVirt DB Issues](/develop/developer-guide/db-issues/db-issues.html)

Obsolete:
- [Gluster Hyperconverged Guide](/dropped/gluster-hyperconverged/Gluster_Hyperconverged_Guide.html)
- [Libvirt logging](/develop/projects/libvirt.html)
- [moVirt Project](/develop/projects/project-movirt.html)

#### Old releases management
- [oVirt 3.0 release management](/develop/release-management/releases/3.0/release-management.html)
- [oVirt 3.1 release management](/develop/release-management/releases/3.1/release-management.html)
- [oVirt 3.2 release management](/develop/release-management/releases/3.2/release-management.html)
- [oVirt 3.3 release management](/develop/release-management/releases/3.3/release-management.html)
- [oVirt 3.4 release management](/develop/release-management/releases/3.4/release-management.html)
- [oVirt 3.5 release management](/develop/release-management/releases/3.5/release-management.html)
- [oVirt 3.6 release management](/develop/release-management/releases/3.6/release-management.html)

#### Old releases
- [oVirt 3.1](/develop/release-management/releases/3.1/release.html)
- [oVirt 3.3](/develop/release-management/releases/3.3/release-announcement.html)
- [oVirt 3.4 features](/develop/release-management/releases/3.4/feature.html)
- [oVirt 3.4 bugs fixed](/develop/release-management/releases/3.4/index-bugs-fixed.html)
- [oVirt 3.4](/develop/release-management/releases/3.4/release-announcement.html)

</section>

</section>
