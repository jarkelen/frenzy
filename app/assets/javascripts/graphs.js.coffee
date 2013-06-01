jQuery ->
  Morris.Bar
    element: 'scores_chart'
    data: $('#scores_chart').data('scores')
    xkey: 'gameround_id'
    ykeys: ['score']
    barColors: ['#008E00']
    labels: ['Score', 'Gameround']
    hideHover: false