class JokersController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @jokers = current_user.jokers.all
    @joker = Joker.new
    #@new_jokers = 3.times { Joker.build }
  end

  def create
    @joker = Joker.new(params[:joker])

    if @joker.save
      redirect_to jokers_path, notice: "Joker #{I18n.t('.created.success')}"
    else
      render action: "new"
    end
  end

  def destroy
    @joker = Joker.find(params[:id])
    @joker.destroy

    redirect_to jokers_url
  end
end
