class UsersController < ApplicationController
  before_filter :authorize

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
end