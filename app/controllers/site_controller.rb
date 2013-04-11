class SiteController < ApplicationController
  def index
    @newsitems = Newsitem.top3.published.paginate(page: params[:page])
  end
end
