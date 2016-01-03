# coding: utf-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_action :forbidden_when_forgot_authorized

  def allow
    @authorized = true
  end

  def forbidden_when_forgot_authorized
    if self.class.ancestors.include?(DeviseController) # deviseは独自の権限管理をしているので除外
      allow
    end
    unless @authorized
      raise Forbidden
    end
  end
end
