class ScoresController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    if params[:gameround]
      @gameround = Gameround.find(params[:gameround])
      unless @gameround.blank?
        @current_gameround = Gameround.find(params[:gameround])
      end
    else
      @gameround = Gameround.where(processed: true).last
      unless @gameround.blank?
        @current_gameround = Gameround.find(@gameround)
      end
    end

    unless @current_gameround.blank?
      @scores = current_user.scores.where("gameround_id = ?", @gameround).paginate(page: params[:page])
      @gamerounds = Gameround.processed.order("number DESC")
    end
  end
end
