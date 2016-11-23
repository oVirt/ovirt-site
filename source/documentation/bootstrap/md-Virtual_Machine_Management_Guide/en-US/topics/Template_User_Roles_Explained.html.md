# Template User Roles Explained

The table below describes the user roles and privileges applicable to using and administrating templates in the User Portal.

| Role | Privileges | Notes |
|-
| TemplateCreator | Can create, edit, manage and remove virtual machine templates within assigned resources. | The **TemplateCreator** role is not applied to a specific template; apply this role to a user for the whole environment with the **Configure** window. Alternatively apply this role for specific data centers, clusters, or storage domains. |
| TemplateOwner | Can edit and delete the template, assign and manage user permissions for the template. | The **TemplateOwner** role is automatically assigned to the user who creates a template. Other users who do not have **TemplateOwner** permissions on a template cannot view or use the template. |
| UserTemplateBasedVm | Can use the template to create virtual machines. | Cannot edit template properties. |
| VnicProfileUser | Logical network and network interface user for templates. | If the **Allow all users to use this Network** option was selected when a logical network is created, **VnicProfileUser** permissions are assigned to all users for the logical network. Users can then attach or detach template network interfaces to or from the logical network. |
