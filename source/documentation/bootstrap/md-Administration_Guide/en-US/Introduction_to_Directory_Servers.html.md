# Introduction to Directory Servers

During installation, Red Hat Virtualization Manager creates an `admin` user on the `internal` domain. The user is also referred to as `admin@internal`. This account is intended for use when initially configuring the environment and for troubleshooting. After you have attached an external directory server, added the directory users, and assigned them with appropriate roles and permissions, the `admin@internal` user can be disabled if it is not required.

The directory servers supported are:

* 389ds

* 389ds RFC-2307 Schema

* Active Directory

* FreeIPA

* Red Hat Identity Management (IdM)

* Novell eDirectory RFC-2307 Schema

* OpenLDAP RFC-2307 Schema

* OpenLDAP Standard Schema

* Oracle Unified Directory RFC-2307 Schema

* RFC-2307 Schema (Generic)

* Red Hat Directory Server (RHDS)

* Red Hat Directory Server (RHDS) RFC-2307 Schema

* iPlanet


**Important:** It is not possible to install Red Hat Virtualization Manager (`rhevm`) and IdM (`ipa-server`) on the same system. IdM is incompatible with the `mod_ssl` package, which is required by Red Hat Virtualization Manager.

**Important:** If you are using Active Directory as your directory server, and you want to use `sysprep` in the creation of templates and virtual machines, then the Red Hat Virtualization administrative user must be delegated control over the Domain to: 

* **Join a computer to the domain**

* **Modify the membership of a group**

For information on creation of user accounts in Active Directory, see [http://technet.microsoft.com/en-us/library/cc732336.aspx](http://technet.microsoft.com/en-us/library/cc732336.aspx).

For information on delegation of control in Active Directory, see [http://technet.microsoft.com/en-us/library/cc732524.aspx](http://technet.microsoft.com/en-us/library/cc732524.aspx).

