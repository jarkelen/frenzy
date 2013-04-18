class UsersController < Clearance::UsersController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @users = User.order("last_name").paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])

    if @user != current_user
      redirect_to root_path, notice: I18n.t('.general.not_authorized')
    end
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