class PeriodsController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @periods = Period.order('period_nr')
  end

  def show
    @period = Period.find(params[:id])
  end

  def edit
    @period = Period.find(params[:id])
  end

  def update
    @period = Period.find(params[:id])

    if @period.update_attributes(params[:period])
      redirect_to periods_path, notice: "Periode #{I18n.t('.updated.success')}"
    else
      render action: "edit"
    end
  end

  def destroy
    @period = Period.find(params[:id])
    @period.destroy

    redirect_to periods_path, notice: "Periode #{I18n.t('.destroyed.success')}"
  end
end
