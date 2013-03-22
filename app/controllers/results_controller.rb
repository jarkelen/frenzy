class ResultsController < ApplicationController
  before_filter :authorize

  def index
    @results = Result.all
  end

  def show
    @result = Result.find(params[:id])
  end

  def new
    @result = Result.new
  end

  def edit
    @result = Result.find(params[:id])
  end

  def create
    @result = Result.new(params[:result])

    if @result.save
      redirect_to @result, notice: "Result #{I18n.t('.successfully_created')}"
    else
      render action: "new"
    end
  end

  def update
    @result = Result.find(params[:id])

    if @result.update_attributes(params[:result])
      redirect_to @result, notice: "Result #{I18n.t('.successfully_updated')}"
    else
      render action: "edit"
    end
  end

  def destroy
    @result = Result.find(params[:id])
    @result.destroy

    redirect_to results_url
  end
end
