class ContantPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin? || user.id == record.user_id
  end

  def create?
    true
  end

  def update?
    user.admin?
  end
end
