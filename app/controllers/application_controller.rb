class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Pundit

  def authorize_user
    authorize current_user
  end

  def authorize_record
    authorize current_record
  end
end
