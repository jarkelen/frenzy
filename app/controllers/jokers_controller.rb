class JokersController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @jokers = current_user.jokers.all
    @joker = Joker.new
    @clubs = current_user.clubs
    @gamerounds = Gameround.active
  end

  def store
    result = false
    unless params[:gameround_id].blank?
      unless params[:club1].blank?
        Joker.create(user_id: params[:user_id], gameround_id: params[:gameround_id], club_id: params[:club1])
      end

      unless params[:club2].blank?
        Joker.create(user_id: params[:user_id], gameround_id: params[:gameround_id], club_id: params[:club2])
      end

      unless params[:club3].blank?
        Joker.create(user_id: params[:user_id], gameround_id: params[:gameround_id], club_id: params[:club3])
      end
      result = true
    end

    if result
      redirect_to jokers_path, notice: "Joker(s) #{I18n.t('.joker.success')}"
    else
      redirect_to jokers_path, notice: "Joker(s) #{I18n.t('.joker.failure')}"
    end
  end

  def destroy
    @joker = Joker.find(params[:id])
    @joker.destroy

    redirect_to jokers_url
  end
end
