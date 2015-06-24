$(function() {
  $widget = $('#calendar-widget')

  if ($widget.length) {

    $.get('/events/calendar.json', function(data){
      $widget.fullCalendar({
        editable: false,
        header: {
          left: 'title',
          firstDay: 1,
          center: '',
          aspectRatio: 1,
          right: 'today prev,next'
        },
        events: data
      });
    });

  }
});
