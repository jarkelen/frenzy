class UsersController < Clearance::UsersController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @users = User.order("last_name").paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def team
    @selections = current_user.selections
  end






  def destroy
    user = User.find(params[:id])
    user.destroy

    redirect_to users_path, notice: "User #{I18n.t('.destroyed.success')}"
  end
end



=begin
class ProfilesController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(params[:profile])

    if @profile.save
      redirect_to user_path(current_user), notice: I18n.t('.profile.created')
    else
      render action: "new"
    end
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile = Profile.find(params[:id])

    if @profile.update_attributes(params[:profile])
      redirect_to user_path(current_user), notice: I18n.t('.profile.updated')
    else
      render action: "edit"
    end
  end
end
=end