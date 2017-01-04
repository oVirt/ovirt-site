# Search Criteria

You can specify the search criteria after the colon in the query. The syntax of `{criteria}` is as follows:

    <prop><operator><value>

or

    <obj-type><prop><operator><value>

**Examples**

The following table describes the parts of the syntax:


**Example Search Criteria**

<table>
 <thead>
  <tr>
   <td>Part</td>
   <td>Description</td>
   <td>Values</td>
   <td>Example</td>
   <td>Note</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>prop</td>
   <td>The property of the searched-for resource. Can also be the property of a resource type (see <tt>obj-type</tt>), or <i>tag</i> (custom tag).</td>
   <td>Limit your search to objects with a certain property. For example, search for objects with a <i>status</i> property.</td>
   <td>Status</td>
   <td>N/A</td>
  </tr>
  <tr>
   <td>obj-type</td>
   <td>A resource type that can be associated with the searched-for resource.</td>
   <td>These are system objects, like data centers and virtual machines.</td>
   <td>Users</td>
   <td>N/A</td>
  </tr>
  <tr>
   <td>operator</td>
   <td>Comparison operators.</td>
   <td>
    <p>=</p>
    <p>!= (not equal)</p>
    <p>&gt;</p>
    <p>&lt;</p>
    <p>&gt;=</p>
    <p>&lt;=</p>
   </td>
   <td>N/A</td>
   <td>Value options depend on obj-type.</td>
  </tr>
  <tr>
   <td>Value</td>
   <td>What the expression is being compared to.</td>
   <td>
    <p>String</p>
    <p>Integer</p>
    <p>Ranking</p>
    <p>Date (formatted according to Regional Settings)</p>
   </td>
   <td>
    <p>Jones</p>
    <p>256</p>
    <p>normal</p>
   </td>
   <td>
    <ul>
     <li>Wildcards can be used within strings.</li>
     <li>"" (two sets of quotation marks with no space between them) can be used to represent an un-initialized (empty) string.</li>
     <li>Double quotes should be used around a string or date containing spaces</li>
    </ul>
   </td>
  </tr>
 </tbody>
</table>
