class SiteController < ApplicationController
  def index
    @newsitems = Newsitem.top3
  end
end
