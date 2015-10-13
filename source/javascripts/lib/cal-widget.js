$(function() {
  $widget = $('#calendar-widget')

  if ($widget.length) {

    $.get('/events/calendar.json', function(data){
      $widget.fullCalendar({
        editable: false,
        eventLimit: 4,
        contentHeight: 'auto',
        header: {
          left: 'title',
          firstDay: 1,
          center: '',
          //aspectRatio: 1,
          right: 'today prev,next'
        },
        //eventColor: '#44aaff',
        events: data
      });
    });

  }
});
