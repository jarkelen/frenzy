module ApplicationHelper
  def markup_boolean(boolean_value)
    if boolean_value == true
      I18n.t('.true')
    else
      I18n.t('.false')
    end
  end
end
