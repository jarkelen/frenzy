module ScoreHelper
  def club_scores_chart_data(club)
    club.scores.map do |score|
      {
        gameround: score.gameround.number,
        score: score.score
      }
    end
  end
end