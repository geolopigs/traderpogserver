class ApplicationController < ActionController::Base
  protect_from_forgery
  skip_before_filter :verify_authenticity_token, :if => :json_request?
  before_filter :authenticate, :unless => :json_request?

  protected
  def json_request?
    request.format.json?
  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "pogadmin" && password == "0nlyP0gs"
    end
  end
end
