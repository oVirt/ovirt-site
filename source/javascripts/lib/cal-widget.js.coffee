$ ->
  $widget = $("#calendar-widget")

  if $widget.length

    tip = '<div id="fc-tooltip" class="fc-tooltip hidden"></div>'
    $widget.after tip
    $tip = $("#fc-tooltip").hide().removeClass('hidden')

    mouseOver = (event, jsEvent, view) ->
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

    mouseOut = (event, jsEvent, view) ->
      $tip.hide().html ""
      return

    $.get "/events/calendar.json", (data) ->
      $widget.fullCalendar
        editable: false
        eventLimit: 4
        contentHeight: "auto"
        header:
          left: "title"
          firstDay: 1
          center: ""
          aspectRatio: 1
          right: "today prev,next" # month,agendaWeek'
        #eventColor: '#44aaff',
        events: data
        eventMouseover: mouseOver
        eventMouseout: mouseOut

      return

  return

