class RankingsController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    if params[:type] == "gameround"
      @current_gameround = Gameround.current.last
      @gameround_rankings = Ranking.current_gameround
    else
      @general_rankings = Ranking.calculate_ranking("general")
      @period_rankings = Ranking.calculate_ranking("period")
    end
  end
end