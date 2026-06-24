(function() {
  $(function() {
    var $tip, $widget, adjustClasses, now, tip, tooltipHide, tooltipShow;
    $widget = $("#calendar-widget");
    now = Date.now();
    if ($widget.length) {
      tip = '<div id="fc-tooltip" class="fc-tooltip hidden"></div>';
      $tip = $(tip).appendTo($widget).hide().removeClass('hidden');
      tooltipShow = function(event, jsEvent, view) {
        var $item, eventInfo, eventText, label, value;
        $item = $(this);
        eventInfo = {
          Title: event.title,
          Host: event.speaker,
          Location: event.location,
          Time: !event.allDay ? event.start.format('h:mm a z') : void 0,
          Topic: event.tags
        };
        eventText = (function() {
          var results;
          results = [];
          for (label in eventInfo) {
            value = eventInfo[label];
            if (value) {
              results.push("<div class=\"fc-tip-" + (label.toLowerCase()) + "\">\n  <span class=\"label\">" + label + ":</span>\n  " + value + "\n</div>");
            } else {
              results.push(void 0);
            }
          }
          return results;
        })();
        $tip.offset({
          top: $item.offset()["top"] - 20,
          left: $item.offset()["left"] - $tip.width() - 40
        }).html(eventText).stop().fadeTo(200, 1);
      };
      tooltipHide = function(event, jsEvent, view) {
        $tip.stop().fadeTo(400, 0);
      };
      adjustClasses = function(event, element, view) {
        var past;
        past = event.end.isBefore(now);
        if (past) {
          $(element[0]).removeClass('current').addClass('old');
        }
      };
      $.get("/events/calendar.json", function(data) {
        $widget.fullCalendar({
          editable: false,
          eventLimit: 4,
          contentHeight: "auto",
          header: {
            left: "title",
            firstDay: 1,
            center: "",
            aspectRatio: 1,
            right: "today prev,next"
          },
          events: data,
          eventMouseover: tooltipShow,
          eventMouseout: tooltipHide,
          eventRender: adjustClasses
        });
      });
    }
  });

}).call(this);
