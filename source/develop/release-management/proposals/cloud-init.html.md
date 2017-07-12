---
title: cloud init
authors: mrao
---

# cloud init

## Alternate concepts for representation of deep hierarchies of information

There is interest to embed the cloud init feature into the Create and Edit VM dialog and this poses an interesting display issue as it increases the amount of hierarchical levels of information to be presented. Here are a few alternate concepts for how this could be presented. Your feedback on these are welcome.

**Base concept - Separate dialog**

Although we try to avoid dialog upon dialog overlay, this may be ok here since the cloud init is a sizeable set of fields that needs to be configured as a supplementary task during the creation or editing of the VM. In the mockup below, the user would see the general fields for Initial Run but a button for Cloud init config and upon clicking of that button, the Cloud init dialog will show up with all relevant fields there. The user would make changes , press ok or cancel and then resume VM configuration here.

![](/images/wiki/Concept0_Button.png)

**Alternate Concept 1 - Sub Sections**

In this concept, on the sub tab panel, 'Cloud Init' is represented in an indented manner and the sections for cloud init are represented as sub section links on the right in the content area. A sub section like Networks can have further nesting of content with the expand/ collapse sections. **NOTE:** We are reserving this type of UI paradigm for cases when the same set of information fields may appear multiple times - in this case the Nic related info.

![](/images/wiki/Concept_1_Sub_Sections.png)

**Alternate Concept 2 - Sub Sections**

In this concept, the subtab panel represents the correct hierarchy of information via traditional indentation. It is possible that the Cloud init and the categories under it display only when the Initial run step is selected. If the Cloud Init step itself has no content, this could be a dummy step and clicking it leads to the first step under it. Content for each step displays on the right including any expand/ collapse sections outlined above in alternate concept 1.

![](/images/wiki/Concept2_Indent.png)

**Alternate Concept 3 - Pages on the left**

In this concept, there is a representation of the sections within cloud init as pages in the form of circles. The user can click on the circle when it changes color to indicate selected state. The name of the section could show as a tooltip on hover but essentially the pages are identified on the right. This concept could work only if the number of sections is limited to 2-5 at max.

![](/images/wiki/Concept_3_pages_on_left.png)

**Alternate Concept 4 - Nested Details**

In this concept, the expand/collapse sections are utilized for the cloud init categories and the next level of information is nested in the form of a master and detail. Specifically, the NICs are added and then for the selected NIC, the details are nested below. This way, the expand collapse is not used for two different levels and types ( categories vs multiple instances of the same info) of information.

![](/images/wiki/Concept4_nested_details.png)
