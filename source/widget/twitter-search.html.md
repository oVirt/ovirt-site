---
title: Twitter Search
authors: dneary
wiki_title: Widget:Twitter Search
wiki_revision_count: 2
wiki_last_updated: 2012-11-29
---

# Twitter Search

<noinclude>__NOTOC__ This widget allows you to embed **[Twitter Search widget](http://twitter.com/goodies/widget_search)** (HTML version) on your wiki page.

Created by [Sergey Chernyshev](http://www.mediawikiwidgets.org/User:Sergey_Chernyshev)

## Using this widget

For information on how to use this widget, see [widget description page on MediaWikiWidgets.org](http://www.mediawikiwidgets.org/Twitter_Search).

## Copy to your site

To use this widget on your site, just install [MediaWiki Widgets extension](http://www.mediawiki.org/wiki/Extension:Widgets) and copy [ full source code] of this page to your wiki as **** article. </noinclude><includeonly>

<script src="http://widgets.twimg.com/j/2/widget.js">
</script>
<script>
new TWTR.Widget({

       version: 2,
       type: 'search',
       search: '` `',
       interval: 6000,
       title: '` `',
       subject: '` `',
       width: ` `,
       height: ` `,
       theme: {
         shell: {
           background: '` `',
           color: '` `'
         },
         tweets: {
           background: '` `',
           color: '` `',
           links: '` `'
         }
       },
       features: {
         scrollbar: false,
         loop: true,
         live: true,
         hashtags: true,
         timestamp: true,
         avatars: true,
         behavior: 'default'
       }

}).render().start();

</script>
</includeonly>
