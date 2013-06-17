class JokersController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @clubs = current_user.clubs
    @gamerounds = Gameround.active
    @all_gamerounds = Gameround.order("number DESC").paginate(page: params[:page])
  end

  def store
    result = Joker.validate_jokers(params[:gameround_id], params[:club1], params[:club2], params[:club3])
    if result
      Joker.create(user_id: params[:user_id], gameround_id: params[:gameround_id], club_id: params[:club1]) unless params[:club1].blank?
      Joker.create(user_id: params[:user_id], gameround_id: params[:gameround_id], club_id: params[:club2]) unless params[:club2].blank?
      Joker.create(user_id: params[:user_id], gameround_id: params[:gameround_id], club_id: params[:club3]) unless params[:club3].blank?

      redirect_to jokers_path, notice: "Joker(s) #{I18n.t('.joker.joker_success')}"
    else
      redirect_to jokers_path, notice: "Joker(s) #{I18n.t('.joker.joker_failure')}"
    end
  end

  def destroy
    @joker = Joker.find(params[:id])
    @joker.destroy

    redirect_to jokers_url
  end
end