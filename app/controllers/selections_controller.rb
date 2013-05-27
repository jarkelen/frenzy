class SelectionsController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @selections = current_user.selections
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

    @leagues = League.order(:level)
    @grouped_clubs = []
    @leagues.each do |league|
      @grouped_clubs << league.league_name
      clubs = Club.where(league_id: league.id)#.within_max_teamvalue(current_user, @current_teamvalue)
      @clubs = []
      clubs.each do |club|
        @clubs << club.club_name
      end
      @grouped_clubs << @clubs
    end

    puts "GROUPED #{@grouped_clubs}"



#    @clubs = Club.within_max_teamvalue(current_user, @current_teamvalue)#.map{ |c| ["#{c.club_name} (#{c.period1})", c.id] }


    #@pl_clubs = Club.includes(:selections).where("clubs.league_id = 1 AND selections.user_id <> 1").map{ |c| ["#{c.club_name} (#{c.period1})", c.id] }

  end

  def create
    @selection = Selection.create(user_id: current_user.id, club_id: params[:club_id])
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


