class SelectionsController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index
    @selection = Selection.new
    @settings = Setting.first
    @leagues = League.order(:level)

    # Determine current team value

    @selections = Player.of_frenzy(current_user).selections
    unless @selections.blank?
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
      @clubs = Club.includes(:league).selectable(Player.of_frenzy(current_user), @current_teamvalue).order('club_name')
    else
      @clubs = Club.includes(:league).order("period#{@settings.current_period} DESC")
    end

    @grouped_clubs = @clubs.inject({}) do |options, club|
      case @settings.current_period
        when 1
          @club_value = club.period1
        when 2
          @club_value = club.period2
        when 3
          @club_value = club.period3
        when 4
          @club_value = club.period4
      end

      (options[club.league.league_name] ||= []) << ["#{club.club_name} (#{@club_value})", club.id]
      options
    end
  end

  def create
    @selection = Selection.create(player_id: Player.of_frenzy(current_user).id, club_id: params[:club_id])
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


