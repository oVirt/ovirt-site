# Search Syntax and Examples

The syntax of the search queries for Red Hat Virtualization resources is as follows:

`result type: {criteria} [sortby sort_spec]`

**Syntax Examples**

The following examples describe how the search query is used and help you to understand how Red Hat Virtualization assists with building search queries.


**Example Search Queries**

| Example | Result |
|-
| Hosts: Vms.status = up | Displays a list of all hosts running virtual machines that are up. |
| Vms: domain = qa.company.com | Displays a list of all virtual machines running on the specified domain. |
| Vms: users.name = Mary | Displays a list of all virtual machines belonging to users with the user name Mary. |
| Events: severity &gt; normal sortby time | Displays the list of all Events whose severity is higher than Normal, sorted by time. |
