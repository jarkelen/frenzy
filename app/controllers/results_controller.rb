class ResultsController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @results = Result.order("gameround_id DESC").paginate(page: params[:page])

    Scraper.new.get_results("Saturday 4th May 2013", "championship")
  end

  def new
    @gamerounds = Gameround.active
    @clubs = Club.all
  end

  def edit
    @result = Result.find(params[:id])
  end

  def store_all
    params[:line].each do |counter, line|
      unless line[:home_club_id].blank?
        Result.create(line.merge(gameround_id: params[:gameround_id]))
      end
    end
    redirect_to results_path, notice: "Results #{I18n.t('.created.success')}"
  end

  def update
    @result = Result.find(params[:id])

    if @result.update_attributes(params[:result])
      redirect_to @result, notice: "Result #{I18n.t('.updated.success')}"
    else
      render action: "edit"
    end
  end

  def destroy
    @result = Result.find(params[:id])
    @result.destroy

    redirect_to results_url
  end

  def scrape_results
    @scenario = Scenario.find(params[:scenario_id])
    if @scenario.execution_delay
      PerformanceWorker.perform_in(@scenario.execution_delay.minutes, params[:scenario_id])
      redirect_to scenarios_url, notice: I18n.t('.scenario.messages.started_in', delay: @scenario.execution_delay)
    else
      PerformanceWorker.perform_async(params[:scenario_id])
      redirect_to scenarios_url, notice: I18n.t('.scenario.messages.started')
    end
  end
end
