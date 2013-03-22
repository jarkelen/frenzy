class GameroundsController < ApplicationController
  def index
    @gamerounds = Gameround.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gamerounds }
    end
  end

  def show
    @gameround = Gameround.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gameround }
    end
  end

  def new
    @gameround = Gameround.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gameround }
    end
  end

  def edit
    @gameround = Gameround.find(params[:id])
  end

  def create
    @gameround = Gameround.new(params[:gameround])

    respond_to do |format|
      if @gameround.save
        format.html { redirect_to @gameround, notice: 'Gameround was successfully created.' }
        format.json { render json: @gameround, status: :created, location: @gameround }
      else
        format.html { render action: "new" }
        format.json { render json: @gameround.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @gameround = Gameround.find(params[:id])

    respond_to do |format|
      if @gameround.update_attributes(params[:gameround])
        format.html { redirect_to @gameround, notice: 'Gameround was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gameround.errors, status: :unprocessable_entity }
      end
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
