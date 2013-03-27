module ApplicationHelper
  def boolean_markup(boolean_value)
    if boolean_value == true
      I18n.t('.true')
    else
      I18n.t('.false')
    end
  end
end
