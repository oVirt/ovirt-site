---
---
$ ->
  $widget = $("#calendar-widget")
  now = Date.now()

  if $widget.length
    # Create tooltip
    tip = '<div id="fc-tooltip" class="fc-tooltip hidden"></div>'
    $tip = $(tip).appendTo($widget).hide().removeClass('hidden')

    # Display the tooltip during mouseover
    tooltipShow = (event, jsEvent, view) ->
      $item = $(this)

      # Collect the event information
      eventInfo =
        Title:    event.title
        Host:     event.speaker
        Location: event.location
        Time:     event.start.format('h:mm a z') unless event.allDay
        Topic:    event.tags

      # Format the event text for the tooltip
      eventText = for label, value of eventInfo
        if value
          """
          <div class="fc-tip-#{label.toLowerCase()}">
            <span class="label">#{label}:</span>
            #{value}
          </div>
          """

      # Position, inject tooltip text, and fade tooltip in
      $tip
        .offset
          top:  $item.offset()["top"] - 20
          left: $item.offset()["left"] - $tip.width() - 40
        .html(eventText)
        .stop().fadeTo(200, 1)
      return

    # Hide the tooltip
    tooltipHide = (event, jsEvent, view) ->
      $tip.stop().fadeTo(400, 0)
      return

    # Set class on past events
    adjustClasses = (event, element, view) ->
      past = event.end.isBefore now

      $(element[0]).removeClass('current').addClass('old') if past

      return

    # Grab calendar JSON and excute code when it is loaded
    $.get "/events/calendar.json", (data) ->

      # Init the calendar widget
      $widget.fullCalendar
        editable: false
        eventLimit: 4
        contentHeight: "auto"
        header:
          left: "title"
          firstDay: 1
          center: ""
          aspectRatio: 1
          right: "today prev,next"
        events: data
        eventMouseover: tooltipShow
        eventMouseout: tooltipHide
        eventRender: adjustClasses

      return

  return

