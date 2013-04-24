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