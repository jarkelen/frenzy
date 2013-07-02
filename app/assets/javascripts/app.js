//$(document).ready(function(){

  $(document).on('click', '#partial_button', function(e) {
    $('#partial_form').show();
    $('#partial_button').hide();
    clubs = $('#club_id').html();
    $('#club_id').empty();
  });

  $(document).on('click', '#partial_cancel', function(e) {
      $('#partial_form').hide();
      $('#partial_button').show();
  });

  $(document).on('change', '#league_id', function(e) {
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

//});
