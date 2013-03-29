class ScoresController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    if params[:gameround_id]
      @gameround = Gameround.find(params[:gameround_id])
    else
      @gameround = Gameround.where(processed: true).last
    end
    @scores = Score.where("gameround_id = ?", @gameround)
  end
end
