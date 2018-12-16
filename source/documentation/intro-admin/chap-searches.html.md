---
title: oVirt Introduction to the Administration Portal
---

# Searches

## Performing Searches in oVirt

The Administration Portal enables the management of thousands of resources, such as virtual machines, hosts, users, and more. To perform a search, enter the search query (free-text or syntax-based) into the search bar. Search queries can be saved as bookmarks for future reuse, so you do not have to reenter a search query each time the specific search results are required. Searches are not case sensitive.

## Syntax Search and Examples

The syntax of the search queries for oVirt resources is as follows:

`result type: {criteria} [sortby sort_spec]`

**Syntax Examples**

The following examples describe how the search query is used and help you to understand how oVirt assists with building search queries.

**Example Search Queries**

| Example |	Result |
|-
| Hosts: Vms.status = up | Displays a list of all hosts running virtual machines that are up. |
| Vms: domain = qa.company.com | Displays a list of all virtual machines running on the specified domain. |
| Vms: users.name = Mary | Displays a list of all virtual machines belonging to users with the user name Mary. |
| Events: severity > normal sortby time | Displays the list of all Events whose severity is higher than Normal, sorted by time. |

## Search Auto-Completion

The Administration Portal provides auto-completion to help you create valid and powerful search queries. As you type each part of a search query, a drop-down list of choices for the next part of the search opens below the Search Bar. You can either select from the list and then continue typing/selecting the next part of the search, or ignore the options and continue entering your query manually.

The following table specifies by example how the Administration Portal auto-completion assists in constructing a query:

`Hosts: Vms.status = down`

**Example Search Queries Using Auto-Completion**

<table class="lt-4-cols lt-7-rows"><colgroup><col style="width: 33%; " class="col_1"><!--Empty--></col><col style="width: 33%; " class="col_2"><!--Empty--></col><col style="width: 33%; " class="col_3"><!--Empty--></col></colgroup><thead><tr><th align="left" valign="top" id="idm140249856110848" scope="col">Input</th><th align="left" valign="top" id="idm140249856109760" scope="col">List Items Displayed</th><th align="left" valign="top" id="idm140249781412656" scope="col">Action</th></tr></thead><tbody><tr><td align="left" valign="top" headers="idm140249856110848"> <p>
								<span class="strong strong"><strong>h</strong></span>
							</p>
							 </td><td align="left" valign="top" headers="idm140249856109760"> <p>
								<code class="literal">Hosts</code> (1 option only)
							</p>
							 </td><td align="left" valign="top" headers="idm140249781412656"> <p>
								Select <code class="literal">Hosts</code> or type <span class="strong strong"><strong>Hosts</strong></span>
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249856110848"> <p>
								<span class="strong strong"><strong>Hosts:</strong></span>
							</p>
							 </td><td align="left" valign="top" headers="idm140249856109760"> <p>
								All host properties
							</p>
							 </td><td align="left" valign="top" headers="idm140249781412656"> <p>
								Type <span class="strong strong"><strong>v</strong></span>
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249856110848"> <p>
								<span class="strong strong"><strong>Hosts: v</strong></span>
							</p>
							 </td><td align="left" valign="top" headers="idm140249856109760"> <p>
								host properties starting with a <code class="literal">v</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249781412656"> <p>
								Select <code class="literal">Vms</code> or type <span class="strong strong"><strong>Vms</strong></span>
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249856110848"> <p>
								<span class="strong strong"><strong>Hosts: Vms</strong></span>
							</p>
							 </td><td align="left" valign="top" headers="idm140249856109760"> <p>
								All virtual machine properties
							</p>
							 </td><td align="left" valign="top" headers="idm140249781412656"> <p>
								Type <span class="strong strong"><strong>s</strong></span>
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249856110848"> <p>
								<span class="strong strong"><strong>Hosts: Vms.s</strong></span>
							</p>
							 </td><td align="left" valign="top" headers="idm140249856109760"> <p>
								All virtual machine properties beginning with <code class="literal">s</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249781412656"> <p>
								Select <code class="literal">status</code> or type <span class="strong strong"><strong>status</strong></span>
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249856110848"> <p>
								<span class="strong strong"><strong>Hosts: Vms.status</strong></span>
							</p>
							 </td><td align="left" valign="top" headers="idm140249856109760"> <p>
								<code class="literal">=</code>
							</p>
							 <p>
								<code class="literal">=!</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249781412656"> <p>
								Select or type <span class="strong strong"><strong>=</strong></span>
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249856110848"> <p>
								<span class="strong strong"><strong>Hosts: Vms.status =</strong></span>
							</p>
							 </td><td align="left" valign="top" headers="idm140249856109760"> <p>
								All status values
							</p>
							 </td><td align="left" valign="top" headers="idm140249781412656"> <p>
								Select or type <span class="strong strong"><strong>down</strong></span>
							</p>
							 </td></tr></tbody></table>

## Search Result Type options

The result type allows you to search for resources of any of the following types:

* **Vms** for a list of virtual machines

* **Host** for a list of hosts

* **Pools** for a list of pools

* **Template** for a list of templates

* **Event** for a list of events

* **Users** for a list of users

* **Cluster** for a list of clusters

* **Datacenter** for a list of data centers

* **Storage** for a list of storage domains

As each type of resource has a unique set of properties and a set of other resource types that it is associated with, each search type has a set of valid syntax combinations. You can also use the auto-complete feature to create valid queries easily.

## Search Criteria

You can specify the search criteria after the colon in the query. The syntax of {criteria} is as follows:

`<prop><operator><value>`

or

`<obj-type><prop><operator><value>`

**Examples**

The following table describes the parts of the syntax:

**Example Search Criteria**

<table class="gt-4-cols lt-7-rows"><colgroup><col style="width: 20%; " class="col_1"><!--Empty--></col><col style="width: 20%; " class="col_2"><!--Empty--></col><col style="width: 20%; " class="col_3"><!--Empty--></col><col style="width: 20%; " class="col_4"><!--Empty--></col><col style="width: 20%; " class="col_5"><!--Empty--></col></colgroup><thead><tr><th align="left" valign="top" id="idm140249847055408" scope="col">Part</th><th align="left" valign="top" id="idm140249847054320" scope="col">Description</th><th align="left" valign="top" id="idm140249847053232" scope="col">Values</th><th align="left" valign="top" id="idm140249848186560" scope="col">Example</th><th align="left" valign="top" id="idm140249848185472" scope="col">Note</th></tr></thead><tbody><tr><td align="left" valign="top" headers="idm140249847055408"> <p>
								prop
							</p>
							 </td><td align="left" valign="top" headers="idm140249847054320"> <p>
								The property of the searched-for resource. Can also be the property of a resource type (see <code class="literal">obj-type</code>), or <span class="strong strong"><strong>tag</strong></span> (custom tag).
							</p>
							 </td><td align="left" valign="top" headers="idm140249847053232"> <p>
								Limit your search to objects with a certain property. For example, search for objects with a <span class="strong strong"><strong>status</strong></span> property.
							</p>
							 </td><td align="left" valign="top" headers="idm140249848186560"> <p>
								Status
							</p>
							 </td><td align="left" valign="top" headers="idm140249848185472"> <p>
								N/A
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847055408"> <p>
								obj-type
							</p>
							 </td><td align="left" valign="top" headers="idm140249847054320"> <p>
								A resource type that can be associated with the searched-for resource.
							</p>
							 </td><td align="left" valign="top" headers="idm140249847053232"> <p>
								These are system objects, like data centers and virtual machines.
							</p>
							 </td><td align="left" valign="top" headers="idm140249848186560"> <p>
								Users
							</p>
							 </td><td align="left" valign="top" headers="idm140249848185472"> <p>
								N/A
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847055408"> <p>
								operator
							</p>
							 </td><td align="left" valign="top" headers="idm140249847054320"> <p>
								Comparison operators.
							</p>
							 </td><td align="left" valign="top" headers="idm140249847053232"> <p>
								=
							</p>
							 <p>
								!= (not equal)
							</p>
							 <p>
								&gt;
							</p>
							 <p>
								&lt;
							</p>
							 <p>
								&gt;=
							</p>
							 <p>
								&lt;=
							</p>
							 </td><td align="left" valign="top" headers="idm140249848186560"> <p>
								N/A
							</p>
							 </td><td align="left" valign="top" headers="idm140249848185472"> <p>
								Value options depend on obj-type.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847055408"> <p>
								Value
							</p>
							 </td><td align="left" valign="top" headers="idm140249847054320"> <p>
								What the expression is being compared to.
							</p>
							 </td><td align="left" valign="top" headers="idm140249847053232"> <p>
								String
							</p>
							 <p>
								Integer
							</p>
							 <p>
								Ranking
							</p>
							 <p>
								Date (formatted according to Regional Settings)
							</p>
							 </td><td align="left" valign="top" headers="idm140249848186560"> <p>
								Jones
							</p>
							 <p>
								256
							</p>
							 <p>
								normal
							</p>
							 </td><td align="left" valign="top" headers="idm140249848185472"> <div class="itemizedlist"><ul class="itemizedlist" type="disc"><li class="listitem">
										Wildcards can be used within strings.
									</li><li class="listitem">
										"" (two sets of quotation marks with no space between them) can be used to represent an un-initialized (empty) string.
									</li><li class="listitem">
										Double quotes should be used around a string or date containing spaces
									</li></ul></div>
							 </td></tr></tbody></table>

## Search: Multiple Criteria and Wildcards

Wildcards can be used in the <value> part of the syntax for strings. For example, to find all users beginning with **m**, enter `m*`.

You can perform a search having two criteria by using the Boolean operators `AND` and `OR`. For example:

`Vms: users.name = m* AND status = Up`

This query returns all running virtual machines for users whose names begin with "m".

`Vms: users.name = m* AND tag = "paris-loc"`

This query returns all virtual machines tagged with "paris-loc" for users whose names begin with "m".

When two criteria are specified without `AND` or `OR`, `AND` is implied. `AND` precedes `OR`, and `OR` precedes implied `AND`.

## Search: Determining Search order

You can determine the sort order of the returned information by using `sortby`. Sort direction (`asc` for ascending, `desc` for descending) can be included.

For example:

`events: severity > normal sortby time desc`

This query returns all Events whose severity is higher than Normal, sorted by time (descending order).

## Searching for Data centers

The following table describes all search options for Data Centers.

**Searching for Data Centers**

<table class="lt-4-cols lt-7-rows"><colgroup><col style="width: 33%; " class="col_1"><!--Empty--></col><col style="width: 33%; " class="col_2"><!--Empty--></col><col style="width: 33%; " class="col_3"><!--Empty--></col></colgroup><thead><tr><th align="left" valign="top" id="idm140249761174032" scope="col">Property (of resource or resource-type)</th><th align="left" valign="top" id="idm140249761172928" scope="col">Type</th><th align="left" valign="top" id="idm140249844440016" scope="col">Description (Reference)</th></tr></thead><tbody><tr><td align="left" valign="top" headers="idm140249761174032"> <p>
								<code class="literal">Clusters.<span class="emphasis"><em>clusters-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249761172928"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249844440016"> <p>
								The property of the clusters associated with the data center.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249761174032"> <p>
								<code class="literal">name</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249761172928"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249844440016"> <p>
								The name of the data center.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249761174032"> <p>
								<code class="literal">description</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249761172928"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249844440016"> <p>
								A description of the data center.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249761174032"> <p>
								<code class="literal">type</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249761172928"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249844440016"> <p>
								The type of data center.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249761174032"> <p>
								<code class="literal">status</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249761172928"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249844440016"> <p>
								The availability of the data center.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249761174032"> <p>
								<code class="literal">sortby</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249761172928"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249844440016"> <p>
								Sorts the returned results by one of the resource properties.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249761174032"> <p>
								<code class="literal">page</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249761172928"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249844440016"> <p>
								The page number of results to display.
							</p>
							 </td></tr></tbody></table>

**Example**

`Datacenter: type = nfs and status != up`

This example returns a list of data centers with a storage type of NFS and status other than up.

## Searching for clusters

The following table describes all search options for clusters.

**Searching Clusters**

<table class="lt-4-cols lt-7-rows"><colgroup><col style="width: 33%; " class="col_1"><!--Empty--></col><col style="width: 33%; " class="col_2"><!--Empty--></col><col style="width: 33%; " class="col_3"><!--Empty--></col></colgroup><thead><tr><th align="left" valign="top" id="idm140249847168224" scope="col">Property (of resource or resource-type)</th><th align="left" valign="top" id="idm140249847167168" scope="col">Type</th><th align="left" valign="top" id="idm140249847166080" scope="col">Description (Reference)</th></tr></thead><tbody><tr><td align="left" valign="top" headers="idm140249847168224"> <p>
								<code class="literal">Datacenter.<span class="emphasis"><em>datacenter-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249847167168"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249847166080"> <p>
								The property of the data center associated with the cluster.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847168224"> <p>
								<code class="literal">Datacenter</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249847167168"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249847166080"> <p>
								The data center to which the cluster belongs.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847168224"> <p>
								<code class="literal">name</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249847167168"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249847166080"> <p>
								The unique name that identifies the clusters on the network.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847168224"> <p>
								<code class="literal">description</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249847167168"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249847166080"> <p>
								The description of the cluster.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847168224"> <p>
								<code class="literal">initialized</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249847167168"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249847166080"> <p>
								True or False indicating the status of the cluster.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847168224"> <p>
								<code class="literal">sortby</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249847167168"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249847166080"> <p>
								Sorts the returned results by one of the resource properties.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847168224"> <p>
								<code class="literal">page</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249847167168"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249847166080"> <p>
								The page number of results to display.
							</p>
							 </td></tr></tbody></table>

**Example**

`Clusters: initialized = true or name = Default`

This example returns a list of clusters which are initialized or named Default.

**Searching for Hosts**

The following table describes all search options for hosts.

**Searching for Hosts**

<table class="lt-4-cols lt-7-rows"><colgroup><col style="width: 33%; " class="col_1"><!--Empty--></col><col style="width: 33%; " class="col_2"><!--Empty--></col><col style="width: 33%; " class="col_3"><!--Empty--></col></colgroup><thead><tr><th align="left" valign="top" id="idm140249847477920" scope="col">Property (of resource or resource-type)</th><th align="left" valign="top" id="idm140249839447328" scope="col">Type</th><th align="left" valign="top" id="idm140249839446240" scope="col">Description (Reference)</th></tr></thead><tbody><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">Vms.<span class="emphasis"><em>Vms-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The property of the virtual machines associated with the host.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">Templates.<span class="emphasis"><em>templates-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The property of the templates associated with the host.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">Events.<span class="emphasis"><em>events-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The property of the events associated with the host.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">Users.<span class="emphasis"><em>users-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The property of the users associated with the host.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">name</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The name of the host.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">status</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The availability of the host.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">external_status</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The health status of the host as reported by external systems and plug-ins.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">cluster</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The cluster to which the host belongs.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">address</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The unique name that identifies the host on the network.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">cpu_usage</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The percent of processing power used.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">mem_usage</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The percentage of memory used.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">network_usage</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The percentage of network usage.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">load</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								Jobs waiting to be executed in the <span class="strong strong"><strong>run-queue</strong></span> per processor, in a given time slice.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">version</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The version number of the operating system.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">cpus</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The number of CPUs on the host.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">memory</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The amount of memory available.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">cpu_speed</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The processing speed of the CPU.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">cpu_model</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The type of CPU.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">active_vms</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The number of virtual machines currently running.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">migrating_vms</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The number of virtual machines currently being migrated.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">committed_mem</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The percentage of committed memory.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">tag</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The tag assigned to the host.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">type</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The type of host.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">datacenter</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The data center to which the host belongs.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">sortby</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								Sorts the returned results by one of the resource properties.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249847477920"> <p>
								<code class="literal">page</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249839447328"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249839446240"> <p>
								The page number of results to display.
							</p>
							 </td></tr></tbody></table>

**Example**

`Hosts: cluster = Default and Vms.os = rhel6`

This example returns a list of hosts which are part of the Default cluster and host virtual machines running the Enterprise Linux 6 operating system.

## Searching for networks

The following table describes all search options for networks.

**Searching for Networks**

<table class="lt-4-cols lt-7-rows"><colgroup><col style="width: 33%; " class="col_1"><!--Empty--></col><col style="width: 33%; " class="col_2"><!--Empty--></col><col style="width: 33%; " class="col_3"><!--Empty--></col></colgroup><thead><tr><th align="left" valign="top" id="idm140249839327872" scope="col">Property (of resource or resource-type)</th><th align="left" valign="top" id="idm140249859709744" scope="col">Type</th><th align="left" valign="top" id="idm140249859708656" scope="col">Description (Reference)</th></tr></thead><tbody><tr><td align="left" valign="top" headers="idm140249839327872"> <p>
								<code class="literal">Cluster_network.<span class="emphasis"><em>clusternetwork-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859709744"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249859708656"> <p>
								The property of the cluster associated with the network.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249839327872"> <p>
								<code class="literal">Host_Network.<span class="emphasis"><em>hostnetwork-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859709744"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249859708656"> <p>
								The property of the host associated with the network.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249839327872"> <p>
								<code class="literal">name</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859709744"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249859708656"> <p>
								The human readable name that identifies the network.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249839327872"> <p>
								<code class="literal">description</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859709744"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249859708656"> <p>
								Keywords or text describing the network, optionally used when creating the network.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249839327872"> <p>
								<code class="literal">vlanid</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859709744"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249859708656"> <p>
								The VLAN ID of the network.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249839327872"> <p>
								<code class="literal">stp</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859709744"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249859708656"> <p>
								Whether Spanning Tree Protocol (STP) is enabled or disabled for the network.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249839327872"> <p>
								<code class="literal">mtu</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859709744"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249859708656"> <p>
								The maximum transmission unit for the logical network.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249839327872"> <p>
								<code class="literal">vmnetwork</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859709744"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249859708656"> <p>
								Whether the network is only used for virtual machine traffic.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249839327872"> <p>
								<code class="literal">datacenter</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859709744"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249859708656"> <p>
								The data center to which the network is attached.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249839327872"> <p>
								<code class="literal">sortby</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859709744"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249859708656"> <p>
								Sorts the returned results by one of the resource properties.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249839327872"> <p>
								<code class="literal">page</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859709744"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249859708656"> <p>
								The page number of results to display.
							</p>
							 </td></tr></tbody></table>

**Example**

`Network: mtu > 1500 and vmnetwork = true`

This example returns a list of networks with a maximum transmission unit greater than 1500 bytes, and which are set up for use by only virtual machines.

## Searching for Storage

The following table describes all search options for storage.

**Searching for Storage**

<table class="lt-4-cols lt-7-rows"><colgroup><col style="width: 33%; " class="col_1"><!--Empty--></col><col style="width: 33%; " class="col_2"><!--Empty--></col><col style="width: 33%; " class="col_3"><!--Empty--></col></colgroup><thead><tr><th align="left" valign="top" id="idm140249861276336" scope="col">Property (of resource or resource-type)</th><th align="left" valign="top" id="idm140249861275280" scope="col">Type</th><th align="left" valign="top" id="idm140249861274192" scope="col">Description (Reference)</th></tr></thead><tbody><tr><td align="left" valign="top" headers="idm140249861276336"> <p>
								<code class="literal">Hosts.<span class="emphasis"><em>hosts-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249861275280"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249861274192"> <p>
								The property of the hosts associated with the storage.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249861276336"> <p>
								<code class="literal">Clusters.<span class="emphasis"><em>clusters-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249861275280"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249861274192"> <p>
								The property of the clusters associated with the storage.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249861276336"> <p>
								<code class="literal">name</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249861275280"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249861274192"> <p>
								The unique name that identifies the storage on the network.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249861276336"> <p>
								<code class="literal">status</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249861275280"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249861274192"> <p>
								The status of the storage domain.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249861276336"> <p>
								<code class="literal">external_status</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249861275280"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249861274192"> <p>
								The health status of the storage domain as reported by external systems and plug-ins.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249861276336"> <p>
								<code class="literal">datacenter</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249861275280"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249861274192"> <p>
								The data center to which the storage belongs.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249861276336"> <p>
								<code class="literal">type</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249861275280"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249861274192"> <p>
								The type of the storage.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249861276336"> <p>
								<code class="literal">size</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249861275280"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249861274192"> <p>
								The size of the storage.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249861276336"> <p>
								<code class="literal">used</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249861275280"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249861274192"> <p>
								The amount of the storage that is used.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249861276336"> <p>
								<code class="literal">committed</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249861275280"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249861274192"> <p>
								The amount of the storage that is committed.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249861276336"> <p>
								<code class="literal">sortby</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249861275280"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249861274192"> <p>
								Sorts the returned results by one of the resource properties.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249861276336"> <p>
								<code class="literal">page</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249861275280"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249861274192"> <p>
								The page number of results to display.
							</p>
							 </td></tr></tbody></table>

**Example**

`Storage: size > 200 or used < 50`

This example returns a list of storage with total storage space greater than 200 GB, or used storage space less than 50 GB.

## Searching for Disks

The following table describes all search options for disks.

    **Note:** You can use the Disk Type and Content Type filtering options to reduce the number of displayed virtual disks.

**Searching for Disks**

<table class="lt-4-cols lt-7-rows"><colgroup><col style="width: 33%; " class="col_1"><!--Empty--></col><col style="width: 33%; " class="col_2"><!--Empty--></col><col style="width: 33%; " class="col_3"><!--Empty--></col></colgroup><thead><tr><th align="left" valign="top" id="idm140249865790752" scope="col">Property (of resource or resource-type)</th><th align="left" valign="top" id="idm140249752703088" scope="col">Type</th><th align="left" valign="top" id="idm140249752702000" scope="col">Description (Reference)</th></tr></thead><tbody><tr><td align="left" valign="top" headers="idm140249865790752"> <p>
								<code class="literal">Datacenters.<span class="emphasis"><em>datacenters-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249752703088"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249752702000"> <p>
								The property of the data centers associated with the disk.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249865790752"> <p>
								<code class="literal">Storages.<span class="emphasis"><em>storages-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249752703088"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249752702000"> <p>
								The property of the storage associated with the disk.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249865790752"> <p>
								<code class="literal">alias</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249752703088"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249752702000"> <p>
								The human readable name that identifies the storage on the network.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249865790752"> <p>
								<code class="literal">description</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249752703088"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249752702000"> <p>
								Keywords or text describing the disk, optionally used when creating the disk.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249865790752"> <p>
								<code class="literal">provisioned_size</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249752703088"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249752702000"> <p>
								The virtual size of the disk.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249865790752"> <p>
								<code class="literal">size</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249752703088"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249752702000"> <p>
								The size of the disk.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249865790752"> <p>
								<code class="literal">actual_size</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249752703088"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249752702000"> <p>
								The actual size allocated to the disk.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249865790752"> <p>
								<code class="literal">creation_date</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249752703088"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249752702000"> <p>
								The date the disk was created.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249865790752"> <p>
								<code class="literal">bootable</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249752703088"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249752702000"> <p>
								Whether the disk can or cannot be booted. Valid values are one of <code class="literal">0</code>, <code class="literal">1</code>, <code class="literal">yes</code>, or <code class="literal">no</code>
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249865790752"> <p>
								<code class="literal">shareable</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249752703088"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249752702000"> <p>
								Whether the disk can or cannot be attached to more than one virtual machine at a time. Valid values are one of <code class="literal">0</code>, <code class="literal">1</code>, <code class="literal">yes</code>, or <code class="literal">no</code>
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249865790752"> <p>
								<code class="literal">format</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249752703088"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249752702000"> <p>
								The format of the disk. Can be one of <code class="literal">unused</code>, <code class="literal">unassigned</code>, <code class="literal">cow</code>, or <code class="literal">raw</code>.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249865790752"> <p>
								<code class="literal">status</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249752703088"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249752702000"> <p>
								The status of the disk. Can be one of <code class="literal">unassigned</code>, <code class="literal">ok</code>, <code class="literal">locked</code>, <code class="literal">invalid</code>, or <code class="literal">illegal</code>.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249865790752"> <p>
								<code class="literal">disk_type</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249752703088"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249752702000"> <p>
								The type of the disk. Can be one of <code class="literal">image</code> or <code class="literal">lun</code>.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249865790752"> <p>
								<code class="literal">number_of_vms</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249752703088"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249752702000"> <p>
								The number of virtual machine(s) to which the disk is attached.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249865790752"> <p>
								<code class="literal">vm_names</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249752703088"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249752702000"> <p>
								The name(s) of the virtual machine(s) to which the disk is attached.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249865790752"> <p>
								<code class="literal">quota</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249752703088"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249752702000"> <p>
								The name of the quota enforced on the virtual disk.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249865790752"> <p>
								<code class="literal">sortby</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249752703088"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249752702000"> <p>
								Sorts the returned results by one of the resource properties.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249865790752"> <p>
								<code class="literal">page</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249752703088"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249752702000"> <p>
								The page number of results to display.
							</p>
							 </td></tr></tbody></table>

**Example**

`Disks: format = cow and provisioned_size > 8`

This example returns a list of virtual disks with QCOW format and an allocated disk size greater than 8 GB.

## Searching for Volumes

The following table describes all search options for volumes.

**Searching for Volumes**

<table class="lt-4-cols lt-7-rows"><colgroup><col style="width: 33%; " class="col_1"><!--Empty--></col><col style="width: 33%; " class="col_2"><!--Empty--></col><col style="width: 33%; " class="col_3"><!--Empty--></col></colgroup><thead><tr><th align="left" valign="top" id="idm140249859056176" scope="col">Property (of resource or resource-type)</th><th align="left" valign="top" id="idm140249859055072" scope="col">Type</th><th align="left" valign="top" id="idm140249859857600" scope="col">Description (Reference)</th></tr></thead><tbody><tr><td align="left" valign="top" headers="idm140249859056176"> <p>
								<code class="literal">Volume.<span class="emphasis"><em>cluster-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859055072"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249859857600"> <p>
								The property of the clusters associated with the volume.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249859056176"> <p>
								<code class="literal">Cluster</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859055072"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249859857600"> <p>
								The name of the cluster associated with the volume.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249859056176"> <p>
								<code class="literal">name</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859055072"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249859857600"> <p>
								The human readable name that identifies the volume.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249859056176"> <p>
								<code class="literal">type</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859055072"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249859857600"> <p>
								Can be one of distribute, replicate, distributed_replicate, stripe, or distributed_stripe.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249859056176"> <p>
								<code class="literal">transport_type</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859055072"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249859857600"> <p>
								Can be one of TCP or RDMA.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249859056176"> <p>
								<code class="literal">replica_count</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859055072"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249859857600"> <p>
								Number of replica.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249859056176"> <p>
								<code class="literal">stripe_count</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859055072"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249859857600"> <p>
								Number of stripes.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249859056176"> <p>
								<code class="literal">status</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859055072"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249859857600"> <p>
								The status of the volume. Can be one of Up or Down.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249859056176"> <p>
								<code class="literal">sortby</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859055072"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249859857600"> <p>
								Sorts the returned results by one of the resource properties.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249859056176"> <p>
								<code class="literal">page</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249859055072"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249859857600"> <p>
								The page number of results to display.
							</p>
							 </td></tr></tbody></table>

**Example**

`Volume: transport_type = rdma and stripe_count >= 2`

This example returns a list of volumes with transport type set to RDMA, and with 2 or more stripes.

## Searching for Virtual machines

The following table describes all search options for virtual machines.

**Searching for Virtual Machines**

<table class="lt-4-cols lt-7-rows"><colgroup><col style="width: 33%; " class="col_1"><!--Empty--></col><col style="width: 33%; " class="col_2"><!--Empty--></col><col style="width: 33%; " class="col_3"><!--Empty--></col></colgroup><thead><tr><th align="left" valign="top" id="idm140249809138544" scope="col">Property (of resource or resource-type)</th><th align="left" valign="top" id="idm140249863297920" scope="col">Type</th><th align="left" valign="top" id="idm140249863296832" scope="col">Description (Reference)</th></tr></thead><tbody><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">Hosts.<span class="emphasis"><em>hosts-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The property of the hosts associated with the virtual machine.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">Templates.<span class="emphasis"><em>templates-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The property of the templates associated with the virtual machine.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">Events.<span class="emphasis"><em>events-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The property of the events associated with the virtual machine.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">Users.<span class="emphasis"><em>users-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The property of the users associated with the virtual machine.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">Storage.<span class="emphasis"><em>storage-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								Depends on the property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The property of storage devices associated with the virtual machine.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">Vnic.<span class="emphasis"><em>mac-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								Depends on the property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The property of the MAC address associated with the virtual machine.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">name</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The name of the virtual machine.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">status</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The availability of the virtual machine.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">ip</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The IP address of the virtual machine.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">uptime</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The number of minutes that the virtual machine has been running.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">domain</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The domain (usually Active Directory domain) that groups these machines.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">os</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The operating system selected when the virtual machine was created.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">creationdate</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								Date
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The date on which the virtual machine was created.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">address</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The unique name that identifies the virtual machine on the network.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">cpu_usage</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The percent of processing power used.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">mem_usage</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The percentage of memory used.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">network_usage</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The percentage of network used.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">memory</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The maximum memory defined.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">apps</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The applications currently installed on the virtual machine.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">cluster</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The cluster to which the virtual machine belongs.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">pool</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The virtual machine pool to which the virtual machine belongs.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">loggedinuser</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The name of the user currently logged in to the virtual machine.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">tag</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The tags to which the virtual machine belongs.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">datacenter</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The data center to which the virtual machine belongs.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">type</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The virtual machine type (server or desktop).
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">quota</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The name of the quota associated with the virtual machine.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">description</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								Keywords or text describing the virtual machine, optionally used when creating the virtual machine.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">sortby</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								Sorts the returned results by one of the resource properties.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">page</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The page number of results to display.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249809138544"> <p>
								<code class="literal">next_run_configuration_exists</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863297920"> <p>
								Boolean
							</p>
							 </td><td align="left" valign="top" headers="idm140249863296832"> <p>
								The virtual machine has pending configuration changes.
							</p>
							 </td></tr></tbody></table>

**Example**

`Vms: template.name = Win* and user.name = ""`

This example returns a list of virtual machines where the template on which the virtual machine is based begins with Win and the virtual machine is assigned to any user.

**Example**

`Vms: cluster = Default and os = windows7`

This example returns a list of virtual machines where the cluster to which the virtual machine belongs is named Default and the virtual machine is running the Windows 7 operating system.

## Searching for pools

The following table describes all search options for Pools.

**Searching for Pools**

<table class="lt-4-cols lt-7-rows"><colgroup><col style="width: 33%; " class="col_1"><!--Empty--></col><col style="width: 33%; " class="col_2"><!--Empty--></col><col style="width: 33%; " class="col_3"><!--Empty--></col></colgroup><thead><tr><th align="left" valign="top" id="idm140249808864192" scope="col">Property (of resource or resource-type)</th><th align="left" valign="top" id="idm140249860809920" scope="col">Type</th><th align="left" valign="top" id="idm140249860808832" scope="col">Description (Reference)</th></tr></thead><tbody><tr><td align="left" valign="top" headers="idm140249808864192"> <p>
								<code class="literal">name</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860809920"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249860808832"> <p>
								The name of the pool.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249808864192"> <p>
								<code class="literal">description</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860809920"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249860808832"> <p>
								The description of the pool.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249808864192"> <p>
								<code class="literal">type</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860809920"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249860808832"> <p>
								The type of pool.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249808864192"> <p>
								<code class="literal">sortby</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860809920"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249860808832"> <p>
								Sorts the returned results by one of the resource properties.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249808864192"> <p>
								<code class="literal">page</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860809920"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249860808832"> <p>
								The page number of results to display.
							</p>
							 </td></tr></tbody></table>

**Example**

`Pools: type = automatic`

This example returns a list of pools with a type of `automatic`.

## Searching for templates

The following table describes all search options for templates.

**Searching for Templates**

<table class="lt-4-cols lt-7-rows"><colgroup><col style="width: 33%; " class="col_1"><!--Empty--></col><col style="width: 33%; " class="col_2"><!--Empty--></col><col style="width: 33%; " class="col_3"><!--Empty--></col></colgroup><thead><tr><th align="left" valign="top" id="idm140249849761680" scope="col">Property (of resource or resource-type)</th><th align="left" valign="top" id="idm140249863599248" scope="col">Type</th><th align="left" valign="top" id="idm140249863598160" scope="col">Description (Reference)</th></tr></thead><tbody><tr><td align="left" valign="top" headers="idm140249849761680"> <p>
								<code class="literal">Vms.<span class="emphasis"><em>Vms-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863599248"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863598160"> <p>
								The property of the virtual machines associated with the template.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249849761680"> <p>
								<code class="literal">Hosts.<span class="emphasis"><em>hosts-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863599248"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863598160"> <p>
								The property of the hosts associated with the template.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249849761680"> <p>
								<code class="literal">Events.<span class="emphasis"><em>events-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863599248"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863598160"> <p>
								The property of the events associated with the template.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249849761680"> <p>
								<code class="literal">Users.<span class="emphasis"><em>users-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863599248"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863598160"> <p>
								The property of the users associated with the template.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249849761680"> <p>
								<code class="literal">name</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863599248"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863598160"> <p>
								The name of the template.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249849761680"> <p>
								<code class="literal">domain</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863599248"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863598160"> <p>
								The domain of the template.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249849761680"> <p>
								<code class="literal">os</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863599248"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863598160"> <p>
								The type of operating system.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249849761680"> <p>
								<code class="literal">creationdate</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863599248"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249863598160"> <p>
								The date on which the template was created.
							</p>
							 <p>
								Date format is <span class="strong strong"><strong>mm/dd/yy</strong></span>.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249849761680"> <p>
								<code class="literal">childcount</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863599248"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249863598160"> <p>
								The number of virtual machines created from the template.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249849761680"> <p>
								<code class="literal">mem</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863599248"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249863598160"> <p>
								Defined memory.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249849761680"> <p>
								<code class="literal">description</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863599248"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863598160"> <p>
								The description of the template.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249849761680"> <p>
								<code class="literal">status</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863599248"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863598160"> <p>
								The status of the template.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249849761680"> <p>
								<code class="literal">cluster</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863599248"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863598160"> <p>
								The cluster associated with the template.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249849761680"> <p>
								<code class="literal">datacenter</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863599248"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863598160"> <p>
								The data center associated with the template.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249849761680"> <p>
								<code class="literal">quota</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863599248"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249863598160"> <p>
								The quota associated with the template.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249849761680"> <p>
								<code class="literal">sortby</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863599248"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249863598160"> <p>
								Sorts the returned results by one of the resource properties.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249849761680"> <p>
								<code class="literal">page</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249863599248"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249863598160"> <p>
								The page number of results to display.
							</p>
							 </td></tr></tbody></table>

**Example**

`Template: Events.severity >= normal and Vms.uptime > 0`

This example returns a list of templates where events of normal or greater severity have occurred on virtual machines derived from the template, and the virtual machines are still running.

## Searching for users

The following table describes all search options for users.

**Searching for Users**

<table class="lt-4-cols lt-7-rows"><colgroup><col style="width: 33%; " class="col_1"><!--Empty--></col><col style="width: 33%; " class="col_2"><!--Empty--></col><col style="width: 33%; " class="col_3"><!--Empty--></col></colgroup><thead><tr><th align="left" valign="top" id="idm140249750604848" scope="col">Property (of resource or resource-type)</th><th align="left" valign="top" id="idm140249750603792" scope="col">Type</th><th align="left" valign="top" id="idm140249750602704" scope="col">Description (Reference)</th></tr></thead><tbody><tr><td align="left" valign="top" headers="idm140249750604848"> <p>
								<code class="literal">Vms.<span class="emphasis"><em>Vms-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249750603792"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249750602704"> <p>
								The property of the virtual machines associated with the user.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249750604848"> <p>
								<code class="literal">Hosts.<span class="emphasis"><em>hosts-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249750603792"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249750602704"> <p>
								The property of the hosts associated with the user.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249750604848"> <p>
								<code class="literal">Templates.<span class="emphasis"><em>templates-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249750603792"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249750602704"> <p>
								The property of the templates associated with the user.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249750604848"> <p>
								<code class="literal">Events.<span class="emphasis"><em>events-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249750603792"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249750602704"> <p>
								The property of the events associated with the user.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249750604848"> <p>
								<code class="literal">name</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249750603792"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249750602704"> <p>
								The name of the user.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249750604848"> <p>
								<code class="literal">lastname</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249750603792"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249750602704"> <p>
								The last name of the user.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249750604848"> <p>
								<code class="literal">usrname</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249750603792"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249750602704"> <p>
								The unique name of the user.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249750604848"> <p>
								<code class="literal">department</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249750603792"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249750602704"> <p>
								The department to which the user belongs.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249750604848"> <p>
								<code class="literal">group</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249750603792"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249750602704"> <p>
								The group to which the user belongs.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249750604848"> <p>
								<code class="literal">title</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249750603792"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249750602704"> <p>
								The title of the user.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249750604848"> <p>
								<code class="literal">status</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249750603792"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249750602704"> <p>
								The status of the user.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249750604848"> <p>
								<code class="literal">role</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249750603792"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249750602704"> <p>
								The role of the user.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249750604848"> <p>
								<code class="literal">tag</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249750603792"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249750602704"> <p>
								The tag to which the user belongs.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249750604848"> <p>
								<code class="literal">pool</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249750603792"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249750602704"> <p>
								The pool to which the user belongs.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249750604848"> <p>
								<code class="literal">sortby</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249750603792"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249750602704"> <p>
								Sorts the returned results by one of the resource properties.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249750604848"> <p>
								<code class="literal">page</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249750603792"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249750602704"> <p>
								The page number of results to display.
							</p>
							 </td></tr></tbody></table>

**Example**

`Users: Events.severity > normal and Vms.status = up or Vms.status = pause`

This example returns a list of users where events of greater than normal severity have occurred on their virtual machines AND the virtual machines are still running; or the users' virtual machines are paused.

## Searching for events

The following table describes all search options you can use to search for events. Auto-completion is offered for many options as appropriate.

**Searching for Events**

<table class="lt-4-cols lt-7-rows"><colgroup><col style="width: 33%; " class="col_1"><!--Empty--></col><col style="width: 33%; " class="col_2"><!--Empty--></col><col style="width: 33%; " class="col_3"><!--Empty--></col></colgroup><thead><tr><th align="left" valign="top" id="idm140249860495248" scope="col">Property (of resource or resource-type)</th><th align="left" valign="top" id="idm140249860494192" scope="col">Type</th><th align="left" valign="top" id="idm140249848083856" scope="col">Description (Reference)</th></tr></thead><tbody><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">Vms.<span class="emphasis"><em>Vms-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								The property of the virtual machines associated with the event.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">Hosts.<span class="emphasis"><em>hosts-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								The property of the hosts associated with the event.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">Templates.<span class="emphasis"><em>templates-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								The property of the templates associated with the event.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">Users.<span class="emphasis"><em>users-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								The property of the users associated with the event.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">Clusters.<span class="emphasis"><em>clusters-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								The property of the clusters associated with the event.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">Volumes.<span class="emphasis"><em>Volumes-prop</em></span></code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								Depends on property type
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								The property of the volumes associated with the event.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">type</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								Type of the event.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">severity</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								The severity of the event: Warning/Error/Normal.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">message</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								Description of the event type.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">time</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								Day the event occurred.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">usrname</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								The user name associated with the event.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">event_host</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								The host associated with the event.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">event_vm</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								The virtual machine associated with the event.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">event_template</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								The template associated with the event.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">event_storage</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								The storage associated with the event.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">event_datacenter</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								The data center associated with the event.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">event_volume</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								String
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								The volume associated with the event.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">correlation_id</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								The identification number of the event.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">sortby</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								List
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								Sorts the returned results by one of the resource properties.
							</p>
							 </td></tr><tr><td align="left" valign="top" headers="idm140249860495248"> <p>
								<code class="literal">page</code>
							</p>
							 </td><td align="left" valign="top" headers="idm140249860494192"> <p>
								Integer
							</p>
							 </td><td align="left" valign="top" headers="idm140249848083856"> <p>
								The page number of results to display.
							</p>
							 </td></tr></tbody></table>

**Example**

`Events: Vms.name = testdesktop and Hosts.name = gonzo.example.com`

This example returns a list of events, where the event occurred on the virtual machine named `testdesktop` while it was running on the host `gonzo.example.com`.

**Prev:** [Chapter 1: Using the Administration Portal](chap-using_the_administration_portal)<br>
**Next:** [Chapter 3: Bookmarks](chap-bookmarks)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/introduction_to_the_administration_portal/chap-searches)
