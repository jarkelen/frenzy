class ScoresController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    if params[:gameround]
      @gameround = Gameround.find(params[:gameround])
      @current_gameround = Gameround.find(params[:gameround])
    else
      @gameround = Gameround.where(processed: true).last
      @current_gameround = Gameround.find(@gameround)
    end
    @scores = current_user.scores.where("gameround_id = ?", @gameround).paginate(page: params[:page])
    @gamerounds = Gameround.processed.order("number DESC")
  end
end
