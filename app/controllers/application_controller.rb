class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery
  before_filter :set_locale

  WillPaginate.per_page = 25

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, notice: I18n.t('.general.not_authorized')
  end

  def set_locale
    if signed_in?
      I18n.locale = current_user.language
    else
      I18n.locale = I18n.default_locale
    end
  end

end
