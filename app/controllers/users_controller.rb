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

  def edit
    @user = User.find(params[:id])
    @clubs = Club.order('club_name ASC')
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to user_path(current_user), notice: I18n.t('.user.updated')
    else
      render action: "edit"
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy

    redirect_to users_path, notice: "User #{I18n.t('.destroyed.success')}"
  end
end
