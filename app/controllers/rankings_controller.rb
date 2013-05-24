class RankingsController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    if params[:type] == "gameround"
      if params[:gameround_id]
        @current_gameround = Gameround.find(params[:gameround_id])
        @gameround_rankings = Ranking.where(gameround_id: params[:gameround_id]).order('total_score DESC')
      else
        @current_gameround = Gameround.current.last
        @gameround_rankings = Ranking.current_gameround
      end
      @gamerounds = Gameround.current.order("number DESC")
    else
      @general_rankings = Ranking.calculate_ranking("general")
      @period_rankings = Ranking.calculate_ranking("period")
    end
    @settings = Setting.first
  end
end