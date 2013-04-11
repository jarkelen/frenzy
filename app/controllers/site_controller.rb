class SiteController < ApplicationController
  def index
    @newsitems = Newsitem.top3.paginate(page: params[:page])
  end
end
