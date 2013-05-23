class SiteController < ApplicationController
  def index
    @sticky_newsitems = Newsitem.sticky
    @newsitems = Newsitem.top3.paginate(page: params[:page])
    @general_rankings = Ranking.calculate_ranking("general")
    @clubs = Club.all
  end
end
