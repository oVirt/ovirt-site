---
title: Outage notice template
category: infra
authors: quaid
---

# Outage notice template

This is a template to use for making announcements about infrastructure outages. Use the template and adjust the variables depending on the situation.

    Subject: (Unplanned) Outage :: $(service_name) :: YYYY-MM-DD HH:MM UTC

    There was an (unplanned) outage of $(service_name) for $(length_of_outage).

    (For planned outages include following block:)

    The outage will occur at YYYY-MM-DD HH:MM UTC. To view in your local time:

    date -d 'YYYY-MM-DD HH:MM UTC'

    == Details ==

    Give full details of the outage: what went wrong, what the plan is, why the outage is planned, etc.

    == Affected services ==

    * Bulleted list
    * of services affected

    === Not-affected services ==

    * Bulleted list
    * of services not affected

    == Future plans ==

    Detail here any plans to fix, mitigate circumstances or risks, etc.

[Category:Infrastructure SOP](/develop/infra/infrastructure-sop.html)
