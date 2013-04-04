class PeriodsController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @periods = Period.all
  end

  def show
    @period = Period.find(params[:id])
  end

  def new
    @period = Period.new
  end

  def edit
    @period = Period.find(params[:id])
  end

  def create
    @period = Period.new(params[:period])

    if @period.save
      redirect_to periods_path, notice: 'Period was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @period = Period.find(params[:id])

    if @period.update_attributes(params[:period])
      redirect_to periods_path, notice: 'Period was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @period = Period.find(params[:id])
    @period.destroy

    respond_to do |format|
      format.html { redirect_to periods_url }
      format.json { head :no_content }
    end
  end
end
