class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery
  before_filter :set_locale

  WillPaginate.per_page = 10

  rescue_from CanCan::AccessDenied do |exception|
    render file: Rails.root.join('public', '403.html'), status: 403, layout: false
  end

  def set_locale
    if signed_in?
      I18n.locale = current_user.language
    else
      I18n.locale = I18n.default_locale
    end
  end
end
