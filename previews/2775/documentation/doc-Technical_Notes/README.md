# Technical Notes

This directory contains content for the Technical Notes document.

The Technical Notes document contains bug text, grouped by product component, that is attached to an errata advisory, and identified by engineering as something that customers should know about.

Not all errata text for all released advisories is included in this document. This document includes text only for those advisories whose total bug text exceeded the errata tool character limit of 4000 characters.

The process and requirements for gathering this text are explained in [The Errata Documentation Process](https://source.redhat.com/groups/public/rhci-documentation-program-management/rhci_documentation_program_management_wiki/the_errata_documentation_process).

## Creating Technical Notes from Errata Text

If the Erratum that's assigned to you for approval has Draft Text that exceeds the Errata Tool's 4000-character limitation, you make that information available to customers by creating a content module in the RHV Technical Notes guide.

### Copy errata content to a new XML doc, create Live ID, add link to Technical Notes

1. If you have not done so already, install the [doc2ascii tool](https://source.redhat.com/groups/public/rhci-documentation-program-management/rhci_documentation_program_management_wiki/installing_and_using_the_asciidoc_converter_doc2ascii) on your system.

1. Determine whether you have "Create Live ID" privileges in the Errata Tool": Open the erratum you are reviewing, select the *Summary* tab, and look for *More* > *Assign Live ID* menu option. If that option is missing, open [Errata Tool - Add New Role](https://redhat.service-now.com/help?id=sc_cat_item&sys_id=be86366113356600196f7e276144b056) and request the "Live ID Creator" role. For details, see [Requesting Access and Roles for a Person](https://errata.devel.redhat.com/user-guide/intro-introduction.html#intro-requesting-access-and-roles-for-a-person). This process can take several days.

1. In the Errata Tool, on the *Summary* tab, click *More* > *Assign Live ID*. This action assigns a new ID to the erratum that it would otherwise get only upon being published.

    NOTE: The Live ID is shorter that the previous ID. For example, in , `RHEA-2020:3246-04`, the `:3246` segment has four digits instead of five.

1. In the Errata Tool *Edit Advisory* tab, in the *Problem Description*, add the following text:

    "A list of bugs fixed in this update is available in the Technical Notes book:

    https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.4/html-single/technical_notes"

    If this is a security advisory (RHSA), add the security fix descriptions that are in the *Draft Text* tab, and save the advisory text.
 
1. Create a git branch for your work on the Technical Notes.

1. Copy the Live ID of the erratum and use it to create an empty XML file in the RHV Technical Notes directory. For example, enter the following command:
`$ touch ~/docs-Red_Hat_Enterprise_Virtualization/doc-Technical_Notes/RHEA-2020:3246-04.xml`

1. Copy the xml content from the *Docs* > *Draft XML* tab in the erratum to the empty XML file you just created. Save the new XML file.

1. For multiple errata, repeat these steps as needed.

### Convert the XML to Asciidoc

1. In a terminal, cd to the `doc-Technical_Notes` directory.

1. Run the following commands:
```
$ rm -rf ./converted
$ doc2ascii
```

1. Move the the converted asciidoc files from `doc-Technical_Notes/converted` up one level. For example, enter:
```
$ mv ./converted/* ./
$ rm -rf ./converted
```

### Clean up the Asciidoc file formatting

* Remove any BZ's that are marked `TBA`. These are "light orange" squares that are missing doc text. If you decide to complete the doc text for any of these, you can easily recreate the XML files and regenerate the asciidoc files now, before you make more substantial edits.

* Copy the full advisory number (for example, RHEA-2020:3246-04) and the *Synopsis* from the errata *Details* tab to create a heading 1 on the first line of the .adoc file. For example:
`= RHEA-2020:3246-04 RHV RHEL Host (ovirt-host) 4.4`

* Add an introductory line with a link to the published advisory. Paste the Live ID into the phrase and the last part of the URL (minus the last hyphen and 2 digits). For example:
```
The bugs in this chapter are addressed by advisory RHEA-2020:3246-04. Further information about this advisory is available at https://access.redhat.com/errata/RHEA-2020:3246.
```

* Change the component names from bold to discrete headings. For example, transform `*vdsm*` to `== vdsm`.

* Each BZ is formatted as [a description list](https://asciidoctor.org/docs/user-manual/#description-list) with a `::` separator. This causes formatting issues. To fix this issue, use **Ctrl+F** & **Replace All** to replace:

    Replace `*` from the beginning of the link with `.` (title period)  and replace  `]::*` from the end of the link with `]`. The final result should look like this:
```
.BZ#link:https://bugzilla.redhat.com/show_bug.cgi?id=1676582[1676582]
```

* At the request of the Localization team we no longer enclose the doc text in Release Notes and Tech Notes in code blocks. Therefore, use **Ctrl+F** & **Replace All** to remove the following lines:
```
[options="nowrap" subs="+quotes,verbatim"]`
----
```

* Update the `master.adoc` file to remove outdated content and include the new xml content file(s). For example:
```
include::RHEA-20203246-04.adoc[leveloffset=+1]
include::RHSA-20203247-08.adoc[leveloffset=+1]
```

* Use [bccutils tool](https://pantheon.int.us-west.aws.prod.paas.redhat.com/#/help/bccutil-install) to generate an html preview of the Tech Notes.

* Review the Tech Notes preview.

* Fix any formatting errors in your `.adoc` files. Rebuild the preview to check your results. Then and copy the reformatted doc text to the **Doc Text** field in the bugzilla. This ensures the problem doesn't reemerge if/when someone regenerates release notes or technical notes from them.

* If you get any stragglers (BZ's whose RDT Flag changes from "Light orange blank" to "Dark orange question mark"), update the Doc Text in the BZ and then manually add it to the technical notes. This way, you avoid repeating conversion and cleanup process described above.

* When you finish updating the Doc Texts, regenerate the Release Notes.

* When the Errata are published, merge and publish your updates to the Tech Notes.

* On release day, review and update the vernum attributes `/docs-Red_Hat_Enterprise_Virtualization/doc-Technical_Notes/common/collateral_files/rhv-attributes.adoc`
