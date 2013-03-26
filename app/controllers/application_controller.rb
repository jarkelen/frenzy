class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery

  before_filter :set_locale
  before_filter :get_settings

  def set_locale
    if signed_in?
      I18n.locale = current_user.language
    else
      I18n.locale = I18n.default_locale
    end
  end

  def get_settings
    setting = Setting.first
    $participation = setting.participation
    $max_teamsize = setting.max_teamsize
    $max_teamvalue = setting.max_teamvalue
    $max_jokers = setting.max_jokers
    $current_period = setting.current_period
  end
end
