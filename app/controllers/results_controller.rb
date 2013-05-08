class ResultsController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @results = Result.order("gameround_id DESC").paginate(page: params[:page])
  end

  def new
    if @results
      @gamerounds = Gameround.active
      @clubs = Club.all
    else
      @leagues = League.all
    end
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

  def scrape
    if params[:league]
      thread = Thread.new do
        scraper = Scraper.new(params[:iterations])
        @results = scraper.get_results(params[:league])
      end
      thread.join
      redirect_to new_result_path, notice: "Results collected"
    end
  end
end
