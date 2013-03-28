module GameroundHelper
  def markup_gameround(gameround)
    "#{I18n.t('.gameround.gameround')} #{gameround.number} (#{gameround.start_date.strftime('%d-%m-%Y')} - #{gameround.end_date.strftime('%d-%m-%Y')})"
  end
end