---
title: Node tips
category: node
authors: dougsland
wiki_title: Node tips
wiki_revision_count: 3
wiki_last_updated: 2012-04-23
---

# Node tips

## Too many logins

To increase the number of users logging into oVirt Node (currently it's 3), edit:

      # vi /etc/security/limits.conf
       *    -    maxlogins 3  
      # persist /etc/security/limits.conf

<Category:Project>
