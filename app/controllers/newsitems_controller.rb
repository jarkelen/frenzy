class NewsitemsController < ApplicationController
  def index
  end

  def new
  end

  def show
    @newsitem = Newsitem.find(params[:id])
    @commentable = @article
    @comments = @commentable.comments
    @comment = Comment.new
  end
end
