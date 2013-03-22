class UsersController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
end