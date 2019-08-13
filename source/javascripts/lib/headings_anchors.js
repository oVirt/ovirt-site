/**
 * jQuery snippet to add anchor links to Markdown posts header
 */

$(function () {
  'use strict';

  $('main').filter('[id]').each(function () {
    var header      = $(this),
        headerID    = header.attr('id'),
        anchorClass = 'header-link',
        anchorIcon  = '<i class="fa fa-link" aria-hidden="true"></i>';

    if (headerID) {
      header.append($('<a />').addClass(anchorClass).attr({ 'href': '#' + headerID, 'aria-hidden': 'true' }).html(anchorIcon));
    }

    return this;
  });
});

