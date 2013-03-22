class LeaguesController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @leagues = League.all
  end

  def show
    @league = League.find(params[:id])
  end

  def new
    @league = League.new
  end

  def edit
    @league = League.find(params[:id])
  end

  def create
    @league = League.new(params[:league])

    if @league.save
      redirect_to @league, notice: 'League was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @league = League.find(params[:id])

    if @league.update_attributes(params[:league])
      redirect_to @league, notice: 'League was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @league = League.find(params[:id])
    @league.destroy

    respond_to do |format|
      format.html { redirect_to leagues_url }
      format.json { head :no_content }
    end
  end
end
