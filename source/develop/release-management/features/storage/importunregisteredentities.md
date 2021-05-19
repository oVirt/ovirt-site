---
title: ImportUnregisteredEntities
authors: mlipchuk
category: feature
---

# Import Unregistered Entities

## Detach/Attach Storage Domain with Entities

### Summary

Currently, the operation of moving entities, such as VMs or Templates, from one Data Center to another Data Center in the same setup must be done through a mediator called Export Storage Domain.
The migration of those entities is done by two copy operations, one to the mediator (Export Storage Domain) and another one from the Export Storage Domain to the target Storage Domain.
Needless to say, those operations require allocation of free space in the Export Storage domain, and take a long time to be complete.
This feature aims at providing this capability without the use of the
mediator, thus saving both space and time.
Currently, we can detach a Storage Domain from the DC only if it is empty, i.e. does not contain any virtual disks.
This new feature would add the ability to detach a Storage Domain containing disks, and re-attach it again to another Data Center.
Each Data Storage Domain is an entity which contains disks and sometime VMs' and Templates' OVF.
The OVF is an XML standard representing the VM/Template configuration, including disks, memory, CPU etc.
Based on this information stored in the Storage Domain, we can relate the disks, VMs and Templates to any Data Center which we will relate the Storage Domain to.

### Owner

* Maor Lipchuk (<mlipchuk@redhat.com>)

### Current status

* Released in oVirt 3.5, additional improvements included in later versions

### General Functionality

* When detaching a Storage Domain the VMs/Templates related to the Storage Domain should be deleted from the engine, but their data will be converted to an XML which will be preserved in a database table called `unregistered_ovf_of_entities`, and will still be part of the OVF disk contained in the Storage Domain.
* When attaching a Storage Domain the user will be able to choose the VMs/Templates/Disks he wants to register to the Data Center, and will choose which cluster and quota for each Vm/Template it will be assigned with.
* After a successful registration of a VM/Template, the entity should be removed from the entities candidates for registration.
* The VM's snapshots and disks (active/deactivate) should be preserved upon attachment, the same as they were when those entities were on the detached Storage Domain.
* Regarding quota enforcement Data Centers, the user will choose for each disk the quota he'll want to consume from, when choosing a VM/Template to register in the setup.

### Restrictions

* Detaching/Attaching a Storage Domain containing entities, should not be restricted by any Data Center version. VMs and Templates can be moved from between older and newer Data Centers with no limitation, except the cluster which the user choose for each VM/Template.
* Detaching will not be permitted if there are VMs/Templates which are delete protected. In case there are such entities, there should be an appropriate message which should indicate those entities names.
* Detaching will also not be permitted if there are VMs which are in PREVIEW mode. In case there are such entities, there should be an appropriate message which should indicate those entities names.
* Detaching will not be permitted if there are VMs which are part of pools. In case there are such entities, there should be an appropriate message which should indicate those entities names.
* A Storage Domain can not be detached if it contains disks which are related to a running VM, unless this disks is inactive.
* Shareable and Direct lun disks are not currently supported in the OVF file.
* The VMs and Templates which are candidates for registration must exist in the Storage Domain OVF contained in the `unregistered_ovf_of_entities` table (see [implementation gap #1](#gaps)).
* If a VM is thinly provisioned from a Template, the registration process will not allow registering it without registering the Template first.
* A Template with disks on multiple Storage Domains will be registered as one copy of the disk related to the source Storage Domain (see [4]).
* Currently, floating disks will be registered using the existing REST command for importing unregistered disk (see [REST](#rest)).
* Permissions on VMs and Templates will not be preserved on detach, since they are not part of the OVF (see [Bug #1108904](https://bugzilla.redhat.com/1108904)).
* Local Storage Domain cannot be detached/attached. This is due to the fact that detaching a Local Storage Domain caused it to be deleted from the host.

<a name="gaps"></a>

#### Implementation gaps

1. VMs/Templates with no disks do not exist in the Storage Domain's OVF, therefore those VMs will not be present in the setup when attaching any domain. (Fixed in oVirt 3.6 - see [Bug #1138134](https://bugzilla.redhat.com/1138134))
2. There should be an option to register a VM even if the Storage Domain does not exist in the Data Center. In this case the VM will be registered with only the available disks. The user will be able to attach the missing Storage Domain at a later phase but he will be able to register those disks to the existing VM only if this VM didn't changed from it's last import (to preserve the snapshot tree of the VM and its images) (see [Bug #1108904](https://bugzilla.redhat.com/1108904))

#### RFEs

* There should be an extra button in the GUI to import all those floating disks. Currently, those disks will not have an alias, which should be fixed once the alias will be saved in the description meta data. (This was delivered in oVirt 4.0 - see [Bug #1138139](https://bugzilla.redhat.com/1138139))
* There should be an extra button to delete any unregistered entity the user doesn't want to register to the setup (see [Bug #1138142](https://bugzilla.redhat.com/1138142))
* We should add the ability to "clone" a VM when the user tries to register an existing VM from a different Storage Domain. "Clone" means that only the VM name will be changed (there will not be any copy operations). This will enable us to a use case of a VM which had two disks on different Storage Domains, and it will be registered once from one Storage Domain and after that it will be registered from another Storage Domain, so in the setup there will be two VMs, each with one disk. (see [Bug #1108904](https://bugzilla.redhat.com/1108904))

### Work flow for detach and attach Storage Domain with entities - UI flow

<iframe width="300" src="//youtube.com/embed/DLcxDB0MY38" frameborder="0" align="right" allowfullscreen="true"> </iframe>

1. Choose an active Storage Domain from an active Data Center, make sure this Storage Domain contains VMs/Templates with disks hosted in the specific Storage Domain
2. Move the Storage Domain to maintenance, and detach it from the Data Center - At this point all the entities related to the Storage Domain should be deleted from the setup
3. Attach the Storage Domain to another Data Center and activate it.
4. After the Storage Domain is activated, navigate to the Storage main tab and pick the Storage Domain which was activated a minute ago
5. In the same Storage main tab, you should see two sub tabs, "Import VMs" and "Import Templates". In the "Import VMs" sub tab, you should see all the VMs which are import candidates, and in the "Import Templates" sub tab, you should see the same only for templates.
6. You can pick several VMs (or Templates), and press on the "import" button.
7. When the "Import" button is pressed, a dialog should be opened, showing the list of all the entities you chose to register.
8. Choose a cluster for each entity which should be compatible for it.
9. You can also view the entity's properties (such as disks or networks) in the sub tab inside the dialog.

#### Import VM/Template sub-tabs

![](/images/wiki/Import_vm_template_subtab.png)

#### Import VM/Template Dialog

![](/images/wiki/Import_vm_template_dialog.png)

<a name="rest"></a>

### REST

#### Get list of unregistered VM/Template

The user can get a list of all the unregistered VMs or unregistered Templates by adding the prefix `;unregistered` after the vms/Templates, in the Storage Domain.
E.g., to get all the unregistered VMs in the Storage Domain `68ca2f73-9b15-4839-83c9-859244ad2cd3` the URL will be `http://localhost:8080/api/storagedomains/68ca2f73-9b15-4839-83c9-859244ad2cd3/vms;unregistered`

![](/images/wiki/UnregisterVM2.png)

#### Register VM to a new cluster

To register a VM to the setup, the URL should indicate `/register` after the VM id: `http://localhost:8080/api/storagedomains/xxxxxxx-xxxx-xxxx-xxxxxx/vms/xxxxxxx-xxxx-xxxx-xxxxxx/register`

![](/images/wiki/UnregisterVM1.png)
