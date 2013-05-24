class SelectionsController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @selections = current_user.selections#.high_to_low
    @selection = Selection.new
    @settings = Setting.first

    # Determine current team value
    @current_teamvalue = 0
    @selections.each do |selection|
      # Determine current period
      case @settings.current_period
        when 1
          @current_period = selection.club.period1
        when 2
          @current_period = selection.club.period2
        when 3
          @current_period = selection.club.period3
        when 4
          @current_period = selection.club.period4
      end
      @current_teamvalue += @current_period
    end

    @pl_clubs = Club.where(league_id: 1).within_max_teamvalue(current_user, @current_teamvalue).map{ |c| ["#{c.club_name} (#{c.period1})", c.id] }
    @ch_clubs = Club.where(league_id: 2).within_max_teamvalue(current_user, @current_teamvalue).map{ |c| ["#{c.club_name} (#{c.period1})", c.id] }
    @l1_clubs = Club.where(league_id: 3).within_max_teamvalue(current_user, @current_teamvalue).map{ |c| ["#{c.club_name} (#{c.period1})", c.id] }
    @l2_clubs = Club.where(league_id: 4).within_max_teamvalue(current_user, @current_teamvalue).map{ |c| ["#{c.club_name} (#{c.period1})", c.id] }
    @cf_clubs = Club.where(league_id: 5).within_max_teamvalue(current_user, @current_teamvalue).map{ |c| ["#{c.club_name} (#{c.period1})", c.id] }
  end

  def create
    @selection = Selection.new(params[:selection])

    if @selection.save
      redirect_to selections_path, notice: "Club #{I18n.t('.created.success')}"
    else
      redirect_to selections_path
    end
  end

  def destroy
    @selection = Selection.find(params[:id])
    @selection.destroy

    redirect_to selections_url, notice: "Club #{I18n.t('.destroyed.success')}"
  end

end


