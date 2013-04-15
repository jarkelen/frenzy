class NewsitemsController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    if current_user.admin?
      @newsitems = Newsitem.newest_first.paginate(page: params[:page])
    else
      @newsitems = Newsitem.newest_first.published.paginate(page: params[:page])
    end
  end

  def show
    @newsitem = Newsitem.find(params[:id])
    @commentable = @newsitem
    @comments = @commentable.comments
    @comment = Comment.new
  end

  def new
    @newsitem = Newsitem.new
  end

  def create
    @newsitem = Newsitem.new(params[:newsitem])

    if @newsitem.save
      redirect_to @newsitem, notice: I18n.t('.news.created')
    else
      render action: "new"
    end
  end

  def edit
    @newsitem = Newsitem.find(params[:id])
  end

  def update
    @newsitem = Newsitem.find(params[:id])

    if @newsitem.update_attributes(params[:newsitem])
      redirect_to @newsitem, notice: I18n.t('.news.updated')
    else
      render action: "edit"
    end
  end

  def destroy
    @newsitem = Newsitem.find(params[:id])
    @newsitem.destroy

    redirect_to newsitems_path, notice: I18n.t('.news.deleted')
  end


end