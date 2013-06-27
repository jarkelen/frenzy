$(document).ready(function(){

  $('#partial_button').click(function(){
      $('#partial_form').show();
      $('#partial_button').hide();
  });

  $('#partial_cancel').click(function(){
      $('#partial_form').hide();
      $('#partial_button').show();
  });

  clubs = $('#club_id').html();
  $('#club_id').empty();
  $('#league_id').change(function() {
    league = $('#league_id :selected').text();
    options = $(clubs).filter("optgroup[label='" + league + "']").html();
    if (options){
      $('#club_id').html(options);
    }
    else {
      $('#club_id').empty();
    }
  });

  $('#mapTab').on('shown', function (e) {
    google.maps.event.trigger(map, 'resize');
  });

});

