# Configuring Host Storage Pool Manager Settings

The Storage Pool Manager (SPM) is a management role given to one of the hosts in a data center to maintain access control over the storage domains. The SPM must always be available, and the SPM role will be assigned to another host if the SPM host becomes unavailable. As the SPM role uses some of the host's available resources, it is important to prioritize hosts that can afford the resources.

The Storage Pool Manager (SPM) priority setting of a host alters the likelihood of the host being assigned the SPM role: a host with high SPM priority will be assigned the SPM role before a host with low SPM priority.

**Configuring SPM settings**

1. Click the **Hosts** resource tab, and select a host from the results list.

2. Click **Edit** to open the **Edit Host** window.

3. Click the **SPM** tab to display the **SPM Priority** settings.

4. Use the radio buttons to select the appropriate SPM priority for the host.

5. Click **OK** to save the settings and close the window.

You have configured the SPM priority of the host.
