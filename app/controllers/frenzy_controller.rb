class FrenzyController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @gamerounds = Gameround.active
    @clubs = Club.all
  end

  def process_gameround
    return unless params[:gameround_id]

    calculator = FrenzyCalculator.new
    calculator.process_gameround(params[:gameround_id])

    redirect_to frenzy_index_path, notice: t('.frenzy.message_calculated')
  end

  def cancel_jokers
    return unless params[:gameround_id]

    calculator = FrenzyCalculator.new
    params[:line].each do |counter, line|
      unless line[:home_club_id].blank?
        calculator.cancel_jokers(line.merge(gameround_id: params[:gameround_id]))
      end
    end
    redirect_to frenzy_index_path, notice: t('.frenzy.message_cancelled')
  end

  def rules
  end

  def switch_period
    calculator = FrenzyCalculator.new
    calculator.switch_period

    redirect_to frenzy_index_path, notice: t('.frenzy.message_period_switched')
  end

  def switch_participation
    setting = Setting.first
    setting.update_attributes(participation: params[:participation])

    redirect_to frenzy_index_path, notice: t('.frenzy.message_participation_switched')
  end

end
