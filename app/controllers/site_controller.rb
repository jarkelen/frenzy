class SiteController < ApplicationController
  def index
    @sticky_newsitems = Newsitem.sticky
    @newsitems = Newsitem.top3.paginate(page: params[:page])
  end
end
