---
title: How to commit oVirt Reports change
category: howto
authors: quaid, yaniv dary
wiki_category: How to
wiki_title: How to commit oVirt Reports change
wiki_revision_count: 2
wiki_last_updated: 2012-03-22
---

<!-- TODO: Content review -->

# How to commit oVirt Reports change

*   Export reports using commend:

      ./js-export.sh --output-dir < temp dir > --everything

*   Replace changed report units or add report units files and xml and to the '.folder.xml' resource list.

      Note: Do the minimal changes possible for the patch. Do not replace the entire repository.

[Category:How to](Category:How to)
