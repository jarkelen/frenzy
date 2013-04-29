class SiteController < ApplicationController
  def index
    @newsitems = Newsitem.top3.published.paginate(page: params[:page])
    @general_rankings = Ranking.calculate_ranking("general")
  end
end
