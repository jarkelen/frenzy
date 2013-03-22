class GameroundsController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @gamerounds = Gameround.all
  end

  def show
    @gameround = Gameround.find(params[:id])
  end

  def new
    @gameround = Gameround.new
  end

  def edit
    @gameround = Gameround.find(params[:id])
  end

  def create
    @gameround = Gameround.new(params[:gameround])

    if @gameround.save
      redirect_to @gameround, notice: 'Gameround was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @gameround = Gameround.find(params[:id])

    if @gameround.update_attributes(params[:gameround])
      redirect_to @gameround, notice: 'Gameround was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @gameround = Gameround.find(params[:id])
    @gameround.destroy

    respond_to do |format|
      format.html { redirect_to gamerounds_url }
      format.json { head :no_content }
    end
  end
end
