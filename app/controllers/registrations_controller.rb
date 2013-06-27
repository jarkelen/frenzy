class RegistrationsController < ApplicationController
  def register_user
    authorize! :manage, User

    @user = User.new
    @random_nr = Random.new.rand(1000...9999)
  end

  def process_user
    authorize! :manage, User

    @user = User.new(params[:user])
    if @user.save
    puts "HUH #{@user.random_nr}"

      redirect_to users_path, notice: "User #{I18n.t('.created.success')}"
    else
      render action: "register_user"
    end
  end
end


