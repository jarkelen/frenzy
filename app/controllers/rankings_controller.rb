class RankingsController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @current_gameround = Gameround.current.last
    @gameround_rankings = Ranking.current_gameround
    @general_rankings = Ranking.calculate_overall_ranking
  end
end