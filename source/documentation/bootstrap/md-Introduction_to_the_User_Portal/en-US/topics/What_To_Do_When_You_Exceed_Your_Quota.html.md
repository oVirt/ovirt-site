# What to Do When You Exceed Your Quota

Red Hat Virtualization provides a resource limitation tool called *quota*, which allows system administrators to limit the amount of CPU and storage each user can consume. Quota compares the amount of virtual resources consumed when you use the virtual machine to the storage allowance and the runtime allowance set by the system administrator.

When you exceed your quota, a pop-up window informs you that you have exceeded your quota, and you will no longer have access to virtual resources. For example, this can happen if you have too many concurrently running virtual machines in your environment.

**Quota exceeded error message**

![](images/1165.png)

To regain access to your virtual machines, do one of the following:

* Shut down the virtual machines that you do not need to bring your resource consumption down to a level that does not exceed the quota. Once the resource consumption level is below the quota you will be able to run virtual machines again.

* If you cannot shut down any existing virtual machines, contact your system administrator to extend your quota allowance or remove any unused virtual machines.

