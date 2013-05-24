class ErrorsController < ApplicationController

  def not_found
    render template: "site/errors/not_found"
  end

  def not_authorized
    render template: "site/errors/not_authorized"
  end

  def internal_server_error
    render template: "site/errors/internal_server_error"
  end

end