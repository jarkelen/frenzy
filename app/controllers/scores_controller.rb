class ScoresController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @gameround = Gameround.where(processed: true).last
#    @scores = Score.where("gameround_id = ? AND club_id IN ?", @gameround, current_user.clubs)
    @scores = Score.where("gameround_id = ?", @gameround)
  end

  def calculate
    #if params[:gameround_id]
      puts "BLA #{params[:gameround_id]}"
    #end
  end
end
