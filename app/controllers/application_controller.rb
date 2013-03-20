class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery

  before_filter :set_locale

  def set_locale
    if signed_in?
      I18n.locale = current_user.language
    else
      I18n.locale = I18n.default_locale
    end
  end

end
