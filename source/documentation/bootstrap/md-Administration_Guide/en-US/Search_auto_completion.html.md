# Search Auto-Completion

The Administration Portal provides auto-completion to help you create valid and powerful search queries. As you type each part of a search query, a drop-down list of choices for the next part of the search opens below the Search Bar. You can either select from the list and then continue typing/selecting the next part of the search, or ignore the options and continue entering your query manually.

The following table specifies by example how the Administration Portal auto-completion assists in constructing a query:

` Hosts: Vms.status = down `

**Example Search Queries Using Auto-Completion**

<table>
 <thead>
  <tr>
   <td>Input</td>
   <td>List Items Displayed</td>
   <td>Action</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><tt> h </tt></td>
   <td><tt>Hosts</tt> (1 option only)</td>
   <td>
    <p>Select <tt>Hosts</tt> or;</p>
    <p>Type <tt> Hosts </tt></p>
   </td>
  </tr>
  <tr>
   <td><tt> Hosts: </tt></td>
   <td>All host properties</td>
   <td>Type <tt> v </tt></td>
  </tr>
  <tr>
   <td><tt> Hosts: v </tt></td>
   <td>host properties starting with a <tt>v</tt></td>
   <td>Select <tt>Vms</tt> or type <tt> Vms </tt></td>
  </tr>
  <tr>
   <td><tt> Hosts: Vms </tt></td>
   <td>All virtual machine properties</td>
   <td>Type <tt> s </tt></td>
  </tr>
  <tr>
   <td><tt> Hosts: Vms.s </tt></td>
   <td>All virtual machine properties beginning with <tt>s</tt></td>
   <td>Select <tt>status</tt> or type <tt> status </tt></td>
  </tr>
  <tr>
   <td><tt> Hosts: Vms.status </tt></td>
   <td>
    <p><tt>=</tt></p>
    <p><tt>=!</tt></p>
   </td>
   <td>Select or type <tt> = </tt></td>
  </tr>
  <tr>
   <td><tt> Hosts: Vms.status = </tt></td>
   <td>All status values</td>
   <td>Select or type <tt> down </tt></td>
  </tr>
 </tbody>
</table>
