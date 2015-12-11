class UserPolicy < ApplicationPolicy
  attr_reader :auth_user, :page_user
  def initialize(auth_user, page_user)
    @auth_user = auth_user
    @page_user = page_user
  end

  def index?
    auth_user.admin?
  end

  def show?
    auth_user.admin? || auth_user.id === page_user.id
  end
end
