---
title: Graduation check list
category: project-acceptance-criteria
authors: cctrieloff, quaid
---

# Graduation check list

## Getting ready for Graduation check list

*   Demonstrated development towards project maturity
*   Demonstrated Integration with one of the listed oVirt APIs
*   Demonstrated the support of the oVirt release schedule
*   Licensing is in order
*   Demonstrate the ability to make a release
*   Basic resources and information around the project is in order
*   Request the oVirt board to vote project to full oVirt status

## Licensing best practice cheat sheet

1.) A COPYING or LICENSE file should be added to the top level of the tree containing the full license text.

If there are multiple licenses for code in the repo, then add multiple LICENSE.XXXX files, and add a master LICENSE file listing which LICENSE.XXXX file applies to which bits of the tree.

2.) Every single .java, .sh, .py, .sql file should have license + copyright boilerplate text added. It should take general format:

      /*
      *   Copyright [yyyy] [name of copyright owner]
      *
      *   Licensed under the Apache License, Version 2.0 (the "License");
      *   you may not use this file except in compliance with the License.
      *   You may obtain a copy of the License at
      *
`*   `[`http://www.apache.org/licenses/LICENSE-2.0`](http://www.apache.org/licenses/LICENSE-2.0)
      *
      *   Unless required by applicable law or agreed to in writing, software
      *   distributed under the License is distributed on an "AS IS" BASIS,
      *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
      *   See the License for the specific language governing permissions and
      *  limitations under the License.
      */

For the Copyright license,

*   Note that the [name of copyright owner] will either be the original authors name or their organization's name. Any additions / changes and the copyright on those can be determined from the GIT history logs.
*   it will suffice to just use '2011' {or the current} as the year for initial publishing, even if the code is older than that for projects that are open sourcing code to an oVirt project.

Adding a filename is useful in case people include your code in another project, so it is clear where it originally came from.

3.) For Java, the Maven POM format allows a section for license information

`    `[`https://maven.apache.org/pom.html#More_Project_Information`](https://maven.apache.org/pom.html#More_Project_Information)

This should be added to all the pom.xml files in the tree.

4.) Unrelated to licensing, add a README file to the top level directory.

This should contain

*   A short paragraph or two describing what the code does
*   A list of licenses the code is under, referring people to the LICENSE or COPYING file(s) for full details
*   A link to the mailing lists, or other relevant developer contact information
*   A link to the bug tracker, or other relevant bug reporting contact information
*   A summary of any relevant external software dependencies that will be required in order to build the software.
*   A quick summary of how to build the software. If the instructions are long & hard, then create a separate INSTALL file with the details instead of cluttering up the README.

5.) provide a public record of the authors, This will be posted on the oVirt site, however it does not hurt to also include an AUTHORS file with details of maintainers & contributors, so people know whom the subject matter experts are.

(Edited from source material from Dan Berrange)

[Category:Project acceptance criteria](Category:Project acceptance criteria)
