module ChartHelper
  def graph_club_scores_data(club)
    all_scores = club.scores.order("gameround_id ASC")
    all_scores.each do |score|
      {
        gameround_id: score.gameround_id,
        score: score.score
      }
    end
  end
end

