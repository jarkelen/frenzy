class RankingsController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    if params[:gameround_id]
      @current_gameround = Gameround.find(params[:gameround_id])
      @gameround_rankings = Ranking.where(gameround_id: params[:gameround_id]).order('total_score DESC')
    else
      @current_gameround = Gameround.where(processed: true).last
      @gameround_rankings = Ranking.current_gameround
    end
    @gamerounds = Gameround.where(processed: true).order("number DESC")
    @settings = Setting.first
  end

  def general
    @general_rankings = Ranking.calculate_ranking("general")
  end

  def period
    @period_rankings = Ranking.calculate_ranking("period")
    @settings = Setting.first
  end
end