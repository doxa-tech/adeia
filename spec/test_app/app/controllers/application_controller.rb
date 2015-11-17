class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from(Adeia::LoginRequired) { |e| redirect_to login_path }
  rescue_from(Adeia::AccessDenied) { |e| redirect_to root_path }
end
