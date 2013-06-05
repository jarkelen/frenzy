class ClubsController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    if params[:league_id]
      @clubs = Club.where(league_id: params[:league_id]).order('league_id, club_name').paginate(page: params[:page])
    else
      @clubs = Club.order('league_id, club_name').paginate(page: params[:page])
    end
    @leagues = League.order(:level)
  end

  def show
    @club = Club.find(params[:id])
  end

  def new
    @club = Club.new
  end

  def edit
    @club = Club.find(params[:id])
  end

  def create
    @club = Club.new(params[:club])

    if @club.save
      redirect_to clubs_url, notice: "Club #{I18n.t('.created.success')}"
    else
      render action: "new"
    end
  end

  def update
    @club = Club.find(params[:id])

    if @club.update_attributes(params[:club])
      redirect_to clubs_url, notice:  "Club #{I18n.t('.updated.success')}"
    else
      render action: "edit"
    end
  end

  def destroy
    @club = Club.find(params[:id])
    @club.destroy

    redirect_to clubs_url, notice: "Club #{I18n.t('.destroyed.success')}"
  end
end
