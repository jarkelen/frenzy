jQuery ->
  Morris.Line
    element: 'scores_chart'
    data: $('#scores_chart').data('scores')
    xkey: 'gameround_id'
    ykeys: ['score']
    lineColors: ['#008E00']
