# User and Administrator Roles

Red Hat Virtualization provides a range of pre-configured roles, from an administrator with system-wide permissions to an end user with access to a single virtual machine. While you cannot change or remove the default roles, you can clone and customize them, or create new roles according to your requirements. There are two types of roles:

* Administrator Role: Allows access to the *Administration Portal* for managing physical and virtual resources. An administrator role confers permissions for actions to be performed in the User Portal; however, it has no bearing on what a user can see in the User Portal.

* User Role: Allows access to the *User Portal* for managing and accessing virtual machines and templates. A user role determines what a user can see in the User Portal. Permissions granted to a user with an administrator role are reflected in the actions available to that user in the User Portal.

For example, if you have an `administrator` role on a cluster, you can manage all virtual machines in the cluster using the *Administration Portal*. However, you cannot access any of these virtual machines in the *User Portal*; this requires a `user` role.
