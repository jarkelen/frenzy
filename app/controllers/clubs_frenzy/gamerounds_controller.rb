class GameroundsController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @gamerounds = Gameround.order('number DESC').paginate(page: params[:page])
  end

  def new
    @gameround = Gameround.new

    if Gameround.all.size == 0
      @new_number = 1
    else
      @new_number = Gameround.last.number + 1
    end
  end

  def create
    @gameround = Gameround.new(params[:gameround])

    if @gameround.save
      redirect_to gamerounds_path, notice: "Gameround #{I18n.t('.created.success')}"
    else
      render action: "new"
    end
  end

  def edit
    @gameround = Gameround.find(params[:id])
  end

  def update
    @gameround = Gameround.find(params[:id])

    if @gameround.update_attributes(params[:gameround])
      redirect_to gamerounds_path, notice: "Gameround #{I18n.t('.updated.success')}"
    else
      render action: "edit"
    end
  end

  def destroy
    @gameround = Gameround.find(params[:id])
    @gameround.destroy

    redirect_to gamerounds_path, notice: "Gameround #{I18n.t('.destroyed.success')}"
  end
end
