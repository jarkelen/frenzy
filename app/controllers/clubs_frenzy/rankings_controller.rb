class RankingsController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    if params[:gameround]
      @current_gameround = Gameround.find(params[:gameround])
      @gameround_rankings = Ranking.where(gameround_id: params[:gameround]).order('total_score DESC')
    else
      @current_gameround = Gameround.where(processed: true).last
      @gameround_rankings = Ranking.where(gameround_id: @current_gameround).order('total_score DESC')
    end
    @gamerounds = Gameround.where(processed: true).order("number DESC")
    @settings = Setting.first
  end

  def general
    @general_rankings = Calculator.new.calculate_total_ranking("general")
  end

  def period
    @period_rankings = Calculator.new.calculate_total_ranking("period")
    @settings = Setting.first
  end
end