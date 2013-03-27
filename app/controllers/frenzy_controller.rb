class FrenzyController < ApplicationController
  before_filter :authorize
  load_and_authorize_resource

  def index

  end
end