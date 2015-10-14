$(function() {
  $widget = $('#calendar-widget')

  if ($widget.length) {
    tip = '<div id="fc-tooltip" class="fc-tooltip"></div>'
    $widget.after(tip);
    $tip = $('#fc-tooltip');

    var mouseOver = function(event, jsEvent, view) {
      var $item = $(this);

      var eventText = '<b>' + event.title + '</b><br>' + 'Time: ' + event.start.format('h:mm a z') + '<br>Location: ' + event.location;

      $tip.html(eventText).show();

      var left = $item.offset()['left'] - $item.width() - $tip.width();
      var top = $item.offset()['top'];

      $tip.offset({top: top, left: left});
      console.log(event.title);
      console.log([event, jsEvent, view]);
      console.log($item.offset());
    };

    var mouseOut = function(event, jsEvent, view) {
      $tip.hide().html('');
    };

    $.get('/events/calendar.json', function(data){
      $widget.fullCalendar({
        editable: false,
        eventLimit: 4,
        contentHeight: 'auto',
        header: {
          left: 'title',
          firstDay: 1,
          center: '',
          aspectRatio: 1,
          right: 'today prev,next'// month,agendaWeek'
        },
        //eventColor: '#44aaff',
        events: data,
        eventMouseover: mouseOver,
        eventMouseout: mouseOut
      });
    });

  }
});
