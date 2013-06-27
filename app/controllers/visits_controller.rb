class VisitsController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    if params[:user]
      visits = User.find(params[:user]).visits.all
    else
      visits = current_user.visits.all
    end
    @map_visits = visits.to_gmaps4rails
    @list_visits = visits
  end

  def all_maps
    @users = User.all
  end

  def new
    @visit = Visit.new
    @visit_nr = current_user.visits.count + 1
  end

  def edit
    @visit = Visit.find(params[:id])
  end

  def create
    @visit = Visit.new(params[:visit])

    if @visit.save
      redirect_to visits_path, notice: I18n.t('.visit.created')
    else
      render action: "new"
    end
  end

  def update
    @visit = Visit.find(params[:id])

    if @visit.update_attributes(params[:visit])
      redirect_to visits_path, notice: I18n.t('.visit.updated')
    else
      render action: "edit"
    end
  end

  def destroy
    @visit = Visit.find(params[:id])
    @visit.destroy

    redirect_to visits_path, notice: I18n.t('.visit.deleted')
  end
end
