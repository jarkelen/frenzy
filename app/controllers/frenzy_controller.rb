class FrenzyController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index

  end

  def process_gameround
    return unless params[:gameround_id]

    calculator = FrenzyCalculator.new
    calculator.process_gameround(params[:gameround_id])

    redirect_to frenzy_index_path, notice: t('.frenzy.message_calculated')
  end

end
