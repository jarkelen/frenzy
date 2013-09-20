module ChartHelper
  def graph_club_scores_data(club)
    all_scores = club.scores.order("gameround_id ASC")
    all_scores.each do |score|
      {
        score: score.score,
        gameround_id: score.gameround_id
      }
    end
  end
end

