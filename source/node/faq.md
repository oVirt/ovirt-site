# Node Next FAQ

**1) What is Node Next?**

Node Next is the Node implementation from oVirt 4.0 . also known as NGN ( Next Generation Node ) or oVirt Node 4.

**2) What is the difference between oVirt Node and Node Next ?**

oVirt Node (vintage Node) was the Node implementation up to oVirt 3.x . </br>
1. In Vintage Node a custom installer was used  - in NGN, anaconda (CentOS/Fedora) installer is used. </br>
2. In Vintage Node a text User-Interface was used for administration - In NGN, Cockpit is used. </br>
3. In Vintage Node the file-system is Read-Only while NGN provide a writable file-system.

**3) Does Node Next work with oVirt 3.6 ?**

Yes. Special configuration is not needed.

**4) How can I install Node Next ?**

See http://www.ovirt.org/node/#quickstart .

**5) How can I update Node Next ?**

use ``` yum update ``` </br>
After installation a user can use yum update to update Node. </br>
In future (oVirt 4.0) Node Next can also be updated through Engine
