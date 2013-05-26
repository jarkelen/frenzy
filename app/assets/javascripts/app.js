$(document).ready(function(){

  $('#partial_button').click(function(){
      $('#partial_form').show();
      $('#partial_button').hide();
  });

  $('#partial_cancel').click(function(){
      $('#partial_form').hide();
      $('#partial_button').show();
  });

  clubs = $('#selection_club_id').html();
  $('#selection_club_id').empty();
  $('#selection_league_id').change(function() {
    league = $('#selection_league_id :selected').text();
    options = $(clubs).filter("optgroup[label='" + league + "']").html();
    if (options){
      $('#selection_club_id').html(options);
    }
    else {
      $('#selection_club_id').empty();
    }
  });

});

