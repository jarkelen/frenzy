class ScoresController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @gameround = Gameround.where(processed: true).last
    @scores = Score.where("gameround_id = ?", @gameround)
  end
end
